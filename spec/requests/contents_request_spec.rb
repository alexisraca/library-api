
require 'rails_helper'

RSpec.describe "ContentsController", type: :request do
  context "POST /pages/:page_id/contents" do
    subject { post contents_path(page), params: payload, headers: headers }

    let!(:book_1) { create(:book) }
    let!(:page_1) { create(:page, book: book_1) }
    let!(:page_2) { create(:page, book: book_1) }
    let!(:page_3) { create(:page, book: book_1) }
    let!(:book_2) { create(:book) }
    let!(:page_4) { create(:page, book: book_2) }
    let!(:page_5) { create(:page, book: book_2) }

    let!(:page) { page_3 }
    let!(:content_format) { create(:content_format, name: "HTML") }

    let(:payload) do
      {
        content: {
          body: "<html></html>",
          file: nil,
          format: content_format.name
        }
      }
    end

    context "authenticated" do
      include_context "authenticated"

      it_behaves_like "http request with code", 201
      it "renders a content" do
        subject
        expect(json["content"]["page_id"]).to eq page_3.id
        expect(json["content"]["content_format_id"]).to eq content_format.id
      end

      it "creates a content" do
        expect { subject }.to change(Content, :count).by(1)
      end

      context "with invalid format" do
        let(:payload) do
          {
            content: {
              body: "<html></html>",
              file: nil,
              format: "XML"
            }
          }
        end

        it_behaves_like "http request with code", 422
      end
    end

    context "not autenticated" do
      it_behaves_like "http request with code", 401
    end
  end

  context "GET /pages/:page_id/contents?format=html" do
    subject { get contents_path(page), params: { format: "html" }, headers: headers }

    let!(:book_1) { create(:book) }
    let!(:page_1) { create(:page, :with_html_content, content_format: content_format, book: book_1) }
    let!(:page_2) { create(:page, :with_html_content, content_format: content_format, book: book_1) }
    let!(:page_3) { create(:page, :with_html_content, content_format: content_format, book: book_1) }
    let!(:book_2) { create(:book) }
    let!(:page_4) { create(:page, :with_html_content, content_format: content_format, book: book_2) }
    let!(:page_5) { create(:page, :with_html_content, content_format: content_format, book: book_2) }

    let(:page) { page_3 }
    let(:content_format) { create(:content_format, name: "HTML") }

    context "authenticated" do
      include_context "authenticated"

      it "returns the content body" do
        subject
        expect(response.body).to eq page.contents.first.body
      end

      it_behaves_like "http request with code", 200

      context "with a page id that doesn't exist" do
        let(:page) { -1 }

        it_behaves_like "http request with code", 404
      end
    end

    context "not autenticated" do
      it_behaves_like "http request with code", 401
    end
  end
end
