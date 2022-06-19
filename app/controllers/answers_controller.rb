# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: :create
  before_action :find_answer, only: :destroy

  def create
    @answer = @question.answers.create(answer_params)
    @answer.user = current_user

    if @answer.save
      redirect_to question_path(@answer.question), notice: 'Your Answer was successfully created'
    else
      render :create
    end
  end

  def destroy
    if @answer.user.author?(@answer)
      @answer.destroy
      redirect_to question_path(@answer.question), notice: 'Answer successfully deleted.'
    end
  end

  private

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def find_question
    @question = if params[:question_id]
                  Question.find(params[:question_id])
                else
                  @answer.question
                end
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
