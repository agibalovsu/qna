class Api::V1::AnswersController < Api::V1::BaseController
	before_action :find_question, only: %i[index]
	before_action :find_answer, only: %i[show]

	authorize_resource

	def index
		render json: @question.answers
	end

	def show
		render json: @answer, serializer: AnswerShowSerializer
	end

	private

	def find_question
		@question = Question.find(params[:question_id])
	end

	def find_answer
		@answer = Answer.find(params[:id])
	end

	def answer_params
		params.require(:answer).permit(:body)
	end	
end