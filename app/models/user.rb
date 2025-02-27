class User < ApplicationRecord

  # include Concerns

  include ExpensePayer
  include SettleUserExpense

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Attribute accessors

  attr_accessor :pay_to
  attr_accessor :amount
  attr_accessor :addition_amount

  # Associations

  has_many :expenses
  has_many :paid_expenses, foreign_key: :payer_id, class_name: "Expense"
  has_many :user_expenses, dependent: :destroy
  # `shared_expenses` will return all the expense
  # including the expense not created by current user
  has_many :shared_expenses, through: :user_expenses, source: "expense"
  has_many :shared_user_expenses, through: :shared_expenses, source: "user_expenses"
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships

  # Callback

  before_create :set_name

  # Methods

  def total_balance
    (self.lent_amount - self.owed_amount).to_f
  end

  def paid_expenses
    cached_shared_expenses.paid_expenses(self.id)
  end

  def borrowed_expenses
    cached_shared_expenses.borrowed_expenses(self.id)
  end

  def cached_shared_expenses
    @cached_shared_expenses ||= self.shared_expenses
  end

  def cache_owed_user_expenses
    @cache_owed_user_expenses ||= user_expenses.owed_expenses(self.id)
  end

  private

  def set_name
    self.name = self.email.split("@").first
  end

  def payer_expense_ids
    # Returns owed expense ids
    @payer_expense_ids ||= cache_owed_user_expenses.pluck(:expense_id).uniq
  end
end
