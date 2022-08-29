class Api::V1::QuestionsController < Api::V1::BaseController
	before_action :find_question, only: %i[show]

	authorize_resource

	def index
		@questions = Question.all
		render json: @questions
	end

	def show
		render json: @question, serializer: QuestionShowSerializer
	end

	private

	def find_question
		@question = Question.find(params[:id])
	end

	def question_params
		params.require(:question).permit(:title, :body)
	end
end