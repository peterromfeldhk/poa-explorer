defmodule Indexer.TokenTransfers do
  @moduledoc """
  Helper functions for transforming data for token transfers.
  """

  alias Explorer.Chain.TokenTransfer

  @doc """
  Returns a list of token transfers given a list of logs.
  """
  def from_log_params(logs) do
    for %{first_topic: unquote(TokenTransfer.constant())} = log <- logs do
      %{
        amount: convert_to_decimal(log.data),
        block_number: log.block_number,
        log_index: log.index,
        from_address_hash: truncate_address_hash(log.second_topic),
        to_address_hash: truncate_address_hash(log.third_topic),
        token_contract_address_hash: log.address_hash,
        transaction_hash: log.transaction_hash
      }
    end
  end

  defp truncate_address_hash("0x000000000000000000000000" <> truncated_hash) do
    "0x#{truncated_hash}"
  end

  defp convert_to_decimal("0x"), do: Decimal.new(0)

  defp convert_to_decimal("0x" <> encoded_decimal) do
    [value] =
      encoded_decimal
      |> Base.decode16!(case: :mixed)
      |> ABI.TypeDecoder.decode_raw([{:uint, 256}])

    Decimal.new(value)
  end

  defp convert_to_decimal(_), do: Decimal.new(0)
end
