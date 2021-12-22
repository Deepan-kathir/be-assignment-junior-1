class ExpensesController < ApplicationController

	# Post /expenses
	def create
		@expense = current_user.expenses.new(expense_params)

		respond_to do |format|
			if @expense.save
				@new_expense = Expense.new

				format.html { redirect_to root_url }
				# As most of the element in dashboard need to be render
				# Reload the page instead of updating elements in JS(in this case entier page)
				format.js { redirect_to root_url }
			else
				format.js
			end
		end
	end

	# def get_item_users
	# 	count = params[:item_count]
	# 	params[:user_ids]
	# 	@e = Expense.create
	# 	count.times do
	# 	  i = @e.items.build
	# 		i.item_users.build
	# 	end
	# end

	private

		def expense_params
			params.require(:expense).permit(
				:amount, 
				:date,
				:description,
				:payer_id,
				:split,
				:tax,
				:initial_amount,
				item_ids: [],
				user_expenses_attributes: [
					:user_id,
					:owed_amount,
					:paid_amount,
					:add_as_friend
				]
			)
		end
end
