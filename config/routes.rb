Rails.application.routes.draw do
  get 'sales_reports', action: :index, controller: "sales_reports"
  get 'sales_reports/weekly', action: :weekly_sales_total, controller: "sales_reports"
  get 'sales_reports/expenses', action: :expense_total, controller: "sales_reports"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
