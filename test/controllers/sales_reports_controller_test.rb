require 'test_helper'

class SalesReportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    Sale.create(date: 3.days.ago, cost: 100)
    Sale.create(date: 2.days.ago, cost: 50)
    Sale.create(date: 8.days.ago, cost: 250)
    Sale.create(date: 10.days.ago, cost: 1000)

    Expense.create(date: 3.days.ago, cost: 100)
    Expense.create(date: Date.today, cost: 130)
  end

  test "it displays report for sales in a given date range" do
    get "/sales_reports?#{8.days.ago.to_date.to_query(:starting)}&#{Date.today.to_query(:ending)}"
    assert @response.body != ""
    json = JSON.parse(@response.body)
    assert_equal "400.0", json["sales_total"]
  end

  test "it displays a weekly sales report" do
    endpoint = "/sales_reports/weekly?#{6.days.ago.to_date.to_query(:starting)}&"
    endpoint += "#{Date.today.to_query(:ending)}"
    get endpoint
    assert @response.body != ""
    json = JSON.parse(@response.body)
    assert_equal "150.0", json["weekly_sales_total"]
  end

  test "it displays an expense report for a given date range" do
    endpoint = "/sales_reports/expenses?#{6.days.ago.to_date.to_query(:starting)}&"
    endpoint += "#{Date.today.to_query(:ending)}"
    get endpoint
    assert @response.body != ""
    json = JSON.parse(@response.body)
    assert_equal "230.0", json["expense_total"]
  end

  test "when given a malformed date, default to today for expenses" do
    endpoint = "/sales_reports/expenses?starting=2019-13-01&"
    endpoint += "ending=2019-13-02"
    get endpoint
    assert @response.body != ""
    json = JSON.parse(@response.body)
    assert_equal "130.0", json["expense_total"]
  end
end

