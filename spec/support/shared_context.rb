RSpec.shared_context "authenticated" do
  let(:user) { create(:user) }
  let(:headers) do
    {
      "Authorization" => JsonWebToken.encode(user_id: user.id),
      'HTTP_ACCEPT' => "application/json" 
    }
  end
end

RSpec.shared_context "http request with code" do |code|
  it "responds with #{code}" do
    subject
    expect(response).to have_http_status(code)
  end
end

RSpec.shared_context "response with json error messages" do
  it "responds with code 422" do
    subject
    expect(response).to have_http_status(422)
  end

  it "has status key with errors" do
    subject
    expect(json["status"]).to eq("error")
  end

  it "has status key with errors" do
    subject
    expect(json["pointers"]).not_to be_empty
  end
end
