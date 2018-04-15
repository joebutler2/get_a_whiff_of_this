class SalesReportsController < ApplicationController
  def index
    render json: {
      sales_total: sales_calculator.sales_total(params),
      weekly_sales_total: weekly_sales_calculator.weekly_sales_total(params),
      expense_total: expense_calculator.expense_total(params)
    }
  end

  # Dependency Injection for Rails Controllers
  # https://bit.ly/2Hr80Ib

  def sales_calculator(calculator=SalesCalculator.new)
    @sales_calculator ||= calculator
  end

  def weekly_sales_calculator(calculator=WeeklySalesCalculator.new)
    @weekly_sales_calculator ||= calculator
  end

  def expense_calculator(calculator=ExpenseCalculator.new)
    @expense_calculator ||= calculator
  end
end

class SalesCalculator
  def sales_total(params)
    Sale
      .where(date: (Date.parse(params[:starting])..Date.parse(params[:ending])))
      .sum("cost")
  end
end

class WeeklySalesCalculator
  def weekly_sales_total(params)
    start_date = Date.parse(params[:starting])
    end_date = start_date + 6
    Sale
      .where(date: (start_date..end_date))
      .sum("cost")
  end
end

class ExpenseCalculator
  def expense_total(params)
    Expense
      .where(date: (Date.parse(params[:starting])..Date.parse(params[:ending])))
      .sum("cost")
  end
end

