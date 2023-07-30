defmodule PeerLearning.ValidationHelper do
  use ExUnit.CaseTemplate

  def errors_on(struct, data) do
    struct.__struct__.changeset(struct, data)
    |> errors_on()
  end

  def errors_on(changeset) do
    changeset
    |> Ecto.Changeset.traverse_errors(fn {_, opts} ->
      Keyword.pop(opts, :validation)
    end)
    |> Enum.flat_map(fn {key, errors} ->
      for info <- errors, do: validation_info(key, info)
    end)
  end

  def without_opts(errors) do
    Enum.map(errors, fn error ->
      case error do
        {key, type} -> {key, type}
        {key, type, _opts} -> {key, type}
      end
    end)
  end

  defp validation_info(key, {type, []}), do: {key, type}

  defp validation_info(key, {type, opts}) when is_list(opts) do
    opts = opts |> Keyword.drop([:count]) |> Enum.sort()
    {key, type, opts}
  end

  defp validation_info(key, errors) when is_map(errors) do
    {key,
     Enum.flat_map(errors, fn {key, errors} ->
       for info <- errors, do: validation_info(key, info)
     end)}
  end

  defp validation_info(key, {type, opts}) when is_map(opts) do
    new_opts = Map.to_list(opts)
    validation_info(key, {type, new_opts})
  end
end
