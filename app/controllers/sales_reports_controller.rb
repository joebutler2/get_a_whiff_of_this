class SalesReportsController < ApplicationController
  def index
    render json: {
      sales_total: sales_calculator.sales_total(date_range),
    }
  end

  def weekly_sales_total
    render json: {
      weekly_sales_total: weekly_sales_calculator.weekly_sales_total(
        date_range(kind: :weekly)
      )
    }
  end

  def expense_total
    render json: {
      expense_total: expense_calculator.expense_total(date_range)
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

  private

  def date_range(kind: :full)
    date_range = case kind
      when :full
        DateRange.new(params[:starting], params[:ending])
      when :weekly
        WeeklyDateRange.new(params[:starting])
      end
    date_range.to_a
  end
end

class SalesCalculator
  def sales_total(date_range)
    Sale
      .where(date: date_range)
      .sum("cost")
  end
end

class WeeklySalesCalculator
  def weekly_sales_total(date_range)
    Sale
      .where(date: date_range)
      .sum("cost")
  end
end

class ExpenseCalculator
  def expense_total(date_range)
    Expense
      .where(date: date_range)
      .sum("cost")
  end
end

class DateRange
  def initialize(start_date, end_date)
    @start_date = Date.parse(start_date) rescue Date.today
    @end_date = Date.parse(end_date) rescue @start_date
  end

  def to_a
    @start_date..@end_date
  end
end

class WeeklyDateRange < DateRange
  def initialize(start_date)
    super(start_date, start_date)
    @end_date = @end_date + 6
  end
end

