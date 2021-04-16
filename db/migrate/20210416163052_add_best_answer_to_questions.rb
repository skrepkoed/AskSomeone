class AddBestAnswerToQuestions < ActiveRecord::Migration[6.0]
  def change
    add_column :questions, :best_answer_id, :integer
    add_foreign_key :questions, :answers, column: :best_answer_id
  end
end
