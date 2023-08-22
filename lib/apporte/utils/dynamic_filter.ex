defmodule PeerLearning.DynamicFilter do
  @moduledoc """
    This module dynamic ecto query filter
  """
  import Ecto.Query, warn: false

  def filter(query, _field_name, _operator, nil, nil), do: query

  def filter(query, :range, :date, from, to) do
    query |> where([m], fragment("?::date BETWEEN ? AND ?", m.inserted_at, ^from, ^to))
  end

  def filter_task_by_start_end_date(query, _field_name, _operator, nil, nil), do: query
  def filter_task_by_start_end_date(query, _field_name, _operator, nil, _to), do: query

  def filter_task_by_start_end_date(query, :range, :date, start_date, end_date) do
    if end_date do
      query
      |> where(
        [m],
        fragment(
          "?::date >= ? AND ?::date <= ?",
          m.start_date,
          ^start_date,
          m.end_date,
          ^end_date
        )
      )
    else
      query |> where([m], fragment("?::date", m.start_date) == ^start_date)
    end
  end

  def filter(query, _field_name, _operator, nil), do: query

  def filter(query, :range, _operator, nil), do: query

  def filter(query, :range, :date, from) do
    query |> where([m], fragment("?::date", m.inserted_at) == ^from)
  end

  def filter(query, field_name, :eq, value) do
    where(query, [record], field(record, ^field_name) == ^value)
  end

  def filter(query, field_name, :neq, value) do
    where(query, [record], field(record, ^field_name) != ^value)
  end

  def filter(query, field_name, :ilike, value) do
    value = "%#{value}%"
    where(query, [record], ilike(field(record, ^field_name), ^value))
  end

  def or_filter(query, _field_name, :ilike, nil), do: query

  def or_filter(query, field_name, :ilike, value) do
    value = "%#{value}%"
    or_where(query, [record], ilike(field(record, ^field_name), ^value))
  end

  def assoc_filter(query, _assoc, _field, _operator, nil), do: query
  def assoc_filter(query, _assoc, _field, _operator, [nil]), do: query

  def assoc_filter(query, assoc, field_name, :eq, value) do
    query
    |> left_join_once(assoc)
    |> where([record, {^assoc, s}], field(s, ^field_name) == ^value)
  end

  def assoc_filter(query, assoc, field_name, :neq, value) do
    query
    |> left_join_once(assoc)
    |> where([record, {^assoc, s}], field(s, ^field_name) != ^value)
  end

  def assoc_filter(query, assoc, field_name, :ilike, value) do
    value = "%#{value}%"

    query
    |> left_join_once(assoc)
    |> where([record, {^assoc, s}], ilike(field(s, ^field_name), ^value))
  end

  def or_assoc_filter(query, _assoc, _field, _operator, nil), do: query
  def or_assoc_filter(query, _assoc, _field, _operator, [nil]), do: query

  def or_assoc_filter(query, assoc, field_name, :ilike, value) do
    value = "%#{value}%"

    query
    |> left_join_once(assoc)
    |> or_where([record, {^assoc, s}], ilike(field(s, ^field_name), ^value))
  end

  def left_join_once(query, assoc) do
    if has_named_binding?(query, assoc) do
      query
    else
      join(query, :left, [record], s in assoc(record, ^assoc), as: ^assoc)
    end
  end
end
