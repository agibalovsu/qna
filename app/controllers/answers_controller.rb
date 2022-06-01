class AnswersController < ApplicationController

	before_action :find_question, only: :create

  def create
    @answer = @question.answers.new(answer_params)

    if @answer.save
      redirect_to question_path(@answer.question)
    else
      render :new
    end
  end

  private

  def set_answer
  	@answer = Answer.find(params[:id])
  end

  def find_question
    if params[:question_id]
      @question = Question.find(params[:question_id])
    else
      @question = @answer.question
    end
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end

