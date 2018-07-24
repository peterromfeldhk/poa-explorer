import $ from 'jquery'
import humps from 'humps'
import router from '../router'
import socket from '../socket'
import { batchChannel, initRedux } from '../utils'

export const initialState = {
  blocks: [],
  channelDisconnected: false
}

export function reducer (state = initialState, action) {
  switch (action.type) {
    case 'PAGE_LOAD': {
      return Object.assign({}, state, {
        blocks: action.blocks
      })
    }
    case 'CHANNEL_DISCONNECTED': {
      return Object.assign({}, state, {
        channelDisconnected: true
      })
    }
    case 'RECEIVED_NEW_BLOCK_BATCH': {
      const incomingBlocks = humps.camelizeKeys(action.msgs).map(msg => msg.homepageBlockHtml).reverse()
      return Object.assign({}, state, {
        blocks: [ ...incomingBlocks, ...state.blocks ].slice(0, state.blocks.length)
      })
    }
    default:
      return state
  }
}

router.when('', { exactPathMatch: true }).then(() => initRedux(reducer, {
  main (store) {
    const blocksChannel = socket.channel(`blocks:new_block`)
    store.dispatch({
      type: 'PAGE_LOAD',
      blocks: $('[data-selector="chain-block"]').toArray().map(el => el.outerHTML)
    })
    blocksChannel.join()
      .receive('ok', resp => { console.log('Joined successfully', 'blocks:new_block', resp) })
      .receive('error', resp => { console.log('Unable to join', 'blocks:new_block', resp) })
    blocksChannel.onError(() => store.dispatch({ type: 'CHANNEL_DISCONNECTED' }))
    blocksChannel.on('new_block', batchChannel(msgs => store.dispatch({ type: 'RECEIVED_NEW_BLOCK_BATCH', msgs })))
  },
  render (state, oldState) {
    const $blockList = $('[data-selector="chain-block-list"]')

    if (oldState.blocks !== state.blocks) $blockList.empty().append(state.blocks)
  }
}))
