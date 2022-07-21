class Link < ApplicationRecord
	GIST_HOST = "gist.github.com"
	URL_FORMAT = /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix

	belongs_to :linkable, polymorphic: true
	validates :name, :url,  presence: true

	validates :url, format: { with: URL_FORMAT, message:'invalid format' }

	def gist?
    URI(url).host == GIST_HOST
  end

  def gist_content
    client = Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])
    gist = client.gist(url.split("/").last)
    file = {}
    gist.files.each { |_, v| file = v }
    file.content
  end
end

