
require 'rails_helper'

RSpec.describe "BooksController", type: :request do
  context "GET /books" do
    let(:payload) { nil }
    subject { get books_path, params: payload, headers: headers }

    context "authenticated" do
      include_context "authenticated"

      let!(:book_1) { create(:book) }
      let!(:book_2) { create(:book) }
      let!(:book_3) { create(:book) }

      it_behaves_like "http request with code", 200
      it "renders a list of books" do
        subject
        expect(json["books"].count).to eq 3
      end

      context "searching" do
        let!(:book_1) { create(:book, name: "abc") }
        let!(:book_2) { create(:book, name: "bcd") }
        let!(:book_3) { create(:book, name: "cde") }

        let(:payload) do
          {
            search: {
              name_cont: "a"
            }
          }
        end

        it "returns only 1 book" do
          subject
          expect(json["books"].count).to eq 1
        end

        it "returns the book with name containing 'a'" do
          subject
          expect(json["books"][0]["id"]).to eq book_1.id
        end
      end

      context "sorting" do
        let(:payload) do
          {
            sort: {
              name: :desc
            }
          }
        end

        let!(:book_1) { create(:book, name: "b") }
        let!(:book_2) { create(:book, name: "f") }
        let!(:book_3) { create(:book, name: "a") }

        context "by default sort" do
          let(:payload) { nil }
          it "sorts by created_at desc" do
            subject
            expect(json["books"][0]["id"]).to eq book_3.id
            expect(json["books"][1]["id"]).to eq book_2.id
            expect(json["books"][2]["id"]).to eq book_1.id
          end
        end

        context "by name desc" do
          it "sorts by name" do
            subject
            expect(json["books"][0]["id"]).to eq book_2.id
            expect(json["books"][1]["id"]).to eq book_1.id
            expect(json["books"][2]["id"]).to eq book_3.id
          end
        end

        context "by name asc" do
          let(:payload) do
            {
              sort: {
                name: :asc
              }
            }
          end

          it "sorts by name" do
            subject
            expect(json["books"][0]["id"]).to eq book_3.id
            expect(json["books"][1]["id"]).to eq book_1.id
            expect(json["books"][2]["id"]).to eq book_2.id
          end
        end

        context "with invalid sortings" do
          let(:payload) do
            {
              sort: {
                unknown_key: :asc
              }
            }
          end

          it_behaves_like "http request with code", 501
        end
      end
    end

    context "not autenticated" do
      it_behaves_like "http request with code", 401
    end
  end

  context "POST /books" do
    subject { post books_path, params: payload, headers: headers }

    let(:payload) do
      {
        book: {
          name: "a name"
        }
      }
    end

    context "authenticated" do
      include_context "authenticated"

      it "creates a book" do
        expect { subject }.to change(Book, :count).by(1)
      end

      it_behaves_like "http request with code", 201

      context "with invalid parameters" do
        let(:payload) do
          {
            book: {
              name: nil
            }
          }
        end

        it "creates a book" do
          expect { subject }.not_to change(Book, :count)
        end

        it_behaves_like "http request with code", 422
        it_behaves_like "response with json error messages"
      end
    end

    context "not autenticated" do
      it_behaves_like "http request with code", 401
    end
  end

  context "PATCH /books/:id" do
    subject { patch book_path(book), params: payload, headers: headers }

    let(:book) { create(:book) }
    let(:payload) do
      {
        book: {
          name: "A new name"
        }
      }
    end

    context "authenticated" do
      include_context "authenticated"

      it_behaves_like "http request with code", 200

      it "changes the book's name" do
        expect { subject }.to change { book.reload.name }
      end

      context "with invalid name" do
        let(:payload) do
          {
            book: {
              name: nil
            }
          }
        end

        it_behaves_like "http request with code", 422
        it_behaves_like "response with json error messages"
      end
    end

    context "not autenticated" do
      let(:user) { create(:user) }
      it_behaves_like "http request with code", 401
    end
  end

  context "DELETE /books/:id" do
    subject { delete book_path(book), params: payload, headers: headers }

    let(:book) { create(:book) }
    let(:payload) { nil }

    context "authenticated" do
      include_context "authenticated"

      it_behaves_like "http request with code", 200

      it "destroys the book" do
        expect { subject }.to change { Book.exists?(book.id) }.to(false)
      end

      context "with an id from a book that doesn't exist" do
        let(:book) { -1 }
        it_behaves_like "http request with code", 404
      end
    end

    context "not autenticated" do
      let(:user) { create(:user) }
      it_behaves_like "http request with code", 401
    end
  end
end
