# frozen_string_literal: true

RSpec::Matchers.define :have_graphql_response do |params|
  match do |response|
    graphql_field = [Types::QueryType, Types::MutationType].map { |klass| klass.fields }.reduce(&:merge).find { |_, v| v.resolver == described_class }

    raise StandardError.new "#{described_class} is not registered" unless graphql_field

    @actual = JSON.parse(response.body).dig('data', graphql_field[0])
    @actual == params
  end

  diffable
end

def execute_graphql(query:, variables:)
  user = create(:user)

  token = jwt_encode(
    iss: jwt_issuer,
    jti: SecureRandom.hex(32),
    exp: (DateTime.now.utc + 10.minutes).to_i,
    sub: user.id,
  )

  post graphql_path, params: { query: query, variables: variables }, headers: { 'Authorization' => "Bearer #{token}" }
end
