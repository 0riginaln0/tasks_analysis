# Анализируем worklog для каждой задачи
defmodule WorklogAnalyzer do
  def calculate_user_time_per_issue(issues) do
    Enum.flat_map(issues, fn issue ->
      %{"worklogs" => worklogs} = issue

      # Группируем время по пользователям для этой задачи
      user_time =
        worklogs
        |> Enum.group_by(fn worklog ->
          worklog["author"]["displayName"] || worklog["author"]["name"]
        end)
        |> Enum.map(fn {user, logs} ->
          total_seconds =
            Enum.reduce(logs, 0, fn log, acc ->
              acc + (log["timeSpentSeconds"] || 0)
            end)

          %{
            issue_key: issue["key"],
            user: user,
            total_seconds: total_seconds,
            total_hours: total_seconds / 3600,
            worklogs_count: length(logs)
          }
        end)

      # Если в задаче есть worklog, возвращаем данные
      if user_time != [] do
        user_time
      else
        []
      end
    end)
  end

  def filter_by_min_time(worklog_data, min_seconds \\ 300) do
    Enum.filter(worklog_data, fn item ->
      item[:total_seconds] >= min_seconds
    end)
  end
end

# Получаем данные о времени пользователей
worklog_data = WorklogAnalyzer.calculate_user_time_per_issue(issues_with_non_empty_worklogs)

IO.puts("Найдено записей worklog: #{Enum.count(worklog_data)}")

# Отфильтруем задачи с очень маленьким временем (меньше 5 минут)
filtered_worklog_data = WorklogAnalyzer.filter_by_min_time(worklog_data, 300)

IO.puts("После фильтрации (≥5 минут): #{Enum.count(filtered_worklog_data)}")
