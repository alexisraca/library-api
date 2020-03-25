
require 'rails_helper'

RSpec.describe "PagesController", type: :request do
  context "GET /books/:book_id/pages/:page_number" do
    subject { get book_page_path(book, page_number), params: nil, headers: headers }

    let!(:book_1) { create(:book) }
    let!(:page_1) { create(:page, book: book_1) }
    let!(:page_2) { create(:page, book: book_1) }
    let!(:page_3) { create(:page, book: book_1) }
    let!(:book_2) { create(:book) }
    let!(:page_4) { create(:page, book: book_2) }
    let!(:page_5) { create(:page, book: book_2) }

    let(:book) { book_1 }
    let(:page_number) { page_3.page_number }

    context "authenticated" do
      include_context "authenticated"

      it_behaves_like "http request with code", 200
      it "renders a page" do
        subject
        expect(json["page"]["id"]).to eq page_3.id
        expect(json["page"]["page_number"]).to eq page_3.page_number
        expect(json["page"]["book_id"]).to eq book_1.id
      end

      context "with a page number that doesn't exist in the book" do
        let(:book) { book_2 }
        let(:page_number) { page_5.page_number + 1 }

        it_behaves_like "http request with code", 404
      end
    end

    context "not autenticated" do
      it_behaves_like "http request with code", 401
    end
  end

  context "POST /books/:book_id/pages/:page_number" do
    subject { post book_pages_path(book), params: nil, headers: headers }

    let!(:book_1) { create(:book) }
    let!(:page_1) { create(:page, book: book_1) }
    let!(:page_2) { create(:page, book: book_1) }
    let!(:page_3) { create(:page, book: book_1) }
    let!(:book_2) { create(:book) }
    let!(:page_4) { create(:page, book: book_2) }
    let!(:page_5) { create(:page, book: book_2) }

    let(:book) { book_1 }

    context "authenticated" do
      include_context "authenticated"

      it "creates a page" do
        expect { subject }.to change(Page, :count).by(1)
      end

      it "returns a new page with the sequential page_number" do
        subject
        expect(json["page"]["page_number"]).to eq page_3.page_number + 1
        expect(json["page"]["book_id"]).to eq book_1.id
      end

      it_behaves_like "http request with code", 201

      context "with a book id that doesn't exist" do
        let(:book) { -1 }

        it "doesn't create a page" do
          expect { subject }.not_to change(Page, :count)
        end

        it_behaves_like "http request with code", 422
        it_behaves_like "response with json error messages"
      end
    end

    context "not autenticated" do
      it_behaves_like "http request with code", 401
    end
  end
end
