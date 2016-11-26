json.extract! ballot_paper, :id, :vote, :created_at, :updated_at
json.url ballot_paper_url(ballot_paper, format: :json)