class Message < ApplicationRecord
  belongs_to :chat
  
  INITIAL_MESSAGE_NUMBER = 1

  ### ELASTICSEARCH ###

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  
  # Define the Elasticsearch index name
  index_name [Rails.application.engine_name, Rails.env].join('_')

  # Define the Elasticsearch mapping
  settings index: { number_of_shards: 1 } do
    mappings dynamic: 'false' do
      indexes :body, type: 'text'
      indexes :chat_key, type: 'text'
    end
  end

  # Override the as_indexed_json method to include only specified attributes in the indexed document
  def as_indexed_json(options = {})
    {
      body: body,
      chat_key: chat_key
    }
  end

  def self.search(query, chat_key, page_size, page)
    page_size = page_size ? [page_size.to_i, 1].max : ElasticsearchConstants::DEFAULT_PAGE_SIZE
    page = page ? [page.to_i, 1].max : ElasticsearchConstants::DEFAULT_PAGE

    offset = (page - 1) * page_size
    __elasticsearch__.search({
      size: page_size,
      from: offset,
      query: {
        bool: {
          must: {
            match: {
              body: {
                query: query,
              }
            }
          },
          filter: {
            term: {
              chat_key: chat_key
            }
          }
        }
      }
    })
  end
end

# to import data from database to elasticsearch
# rake environment elasticsearch:import:model CLASS='Message' FORCE=y
