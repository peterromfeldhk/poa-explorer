defmodule Indexer.TokenTransfersTest do
  use ExUnit.Case

  alias Indexer.TokenTransfers

  test "from_log_params/2" do
    logs = [
      %{
        address_hash: "0xf2eec76e45b328df99a34fa696320a262cb92154",
        block_number: 3_530_917,
        data: "0x000000000000000000000000000000000000000000000000ebec21ee1da40000",
        first_topic: "0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef",
        fourth_topic: nil,
        index: 8,
        second_topic: "0x000000000000000000000000556813d9cc20acfe8388af029a679d34a63388db",
        third_topic: "0x00000000000000000000000092148dd870fa1b7c4700f2bd7f44238821c26f73",
        transaction_hash: "0x43dfd761974e8c3351d285ab65bee311454eb45b149a015fe7804a33252f19e5",
        type: "mined"
      },
      %{
        address_hash: "0x6ea5ec9cb832e60b6b1654f5826e9be638f276a5",
        block_number: 3586935,
        data: "0x",
        first_topic: "0x55e10366a5f552746106978b694d7ef3bbddec06bd5f9b9d15ad46f475c653ef",
        fourth_topic: "0xc89efdaa54c0f20c7adf612882df0950f5a951637e0307cdcb4c672f298b8bc6",
        index: 0,
        second_topic: "0x00000000000000000000000063b0595bb7a0b7edd0549c9557a0c8aee6da667b",
        third_topic: "0x000000000000000000000000f3089e15d0c23c181d7f98b0878b560bfe193a1d",
        transaction_hash: "0x8425a9b81a9bd1c64861110c1a453b84719cb0361d6fa0db68abf7611b9a890e",
        type: "mined"
      }
    ]

    expected = [%{
      amount: Decimal.new(17_000_000_000_000_000_000),
      block_number: 3_530_917,
      log_index: 8,
      from_address_hash: "0x556813d9cc20acfe8388af029a679d34a63388db",
      to_address_hash: "0x92148dd870fa1b7c4700f2bd7f44238821c26f73",
      token_contract_address_hash: "0xf2eec76e45b328df99a34fa696320a262cb92154",
      transaction_hash: "0x43dfd761974e8c3351d285ab65bee311454eb45b149a015fe7804a33252f19e5",
    }]

    assert TokenTransfers.from_log_params(logs) == expected
  end
end
