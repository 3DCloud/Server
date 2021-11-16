# frozen_string_literal: true

RSpec::Matchers.define :have_graphql_response do |params|
  match do |response|
    @actual = JSON.parse(response.body)
    @actual == params
  end

  diffable
end

def execute_graphql(query:, variables:, user_role: 'regular_user')
  user = create(:user, role: user_role)

  token = jwt_encode(
    iss: jwt_issuer,
    jti: SecureRandom.hex(32),
    exp: (DateTime.now.utc + 10.minutes).to_i,
    sub: user.id,
  )

  post graphql_path, params: { query: query, variables: variables }, headers: { 'Authorization' => "Bearer #{token}" }
end
