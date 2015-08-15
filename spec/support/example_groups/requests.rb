# Define some common HTTP request examples:
RSpec.shared_examples "a HTTP request" do |endpoint, params, response_code|
  subject do
    get endpoint, params
  end
  it do
    expect(subject).to have_http_status(response_code)
  end
end

RSpec.shared_examples "a well-formed HTML request" do |endpoint, params|
  it_behaves_like "a HTTP request", endpoint, params, :success
end