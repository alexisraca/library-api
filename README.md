# Setup

* Database: Postgresql (could've used sqlite3 but to deploy it in Heroku it required pg gem)
* Test suite: Rspec
* Search: Ransack
* Pagination: Kaminari
* Authentication: JWT and bcrypt
* Serialization: Activemodel Serialziers (:json format)

To setup the database locally just add your configurations to a new `.env` file. Use the included `.env.example` in the project

Create your own keybase using: 

`EDITOR=vim rails credentials:edit`

 And save the file, this will create a `master.key` file. Otherwise the JWT encryption process will fail.

```
bundle install
rails db:setup

# or 

rails db:create
rails db:migrate
rails db:seed
```

# Postman

Collection of Postman Requests and examples in: https://www.getpostman.com/collections/d33434f8851577711add

It contains examples of successfull and failures for each request.

### Heroku temporal server

I uploaded a test server in Heroku, it can be found in: https://library-api-blue.herokuapp.com/

Check seeds for password and email. It can be tested with Postman, just change the {{service_url}} variable or string in the path to https://library-api-blue.herokuapp.com/

# API

Authenticate through the /authenticate endpoint sending email and password:
```
# POST /authenticate

{
  "email": "email-in-seeds-rb-file@email.com",
  "password": "password-in-seeds-rb-file"
}
```
Authentication when successfull will set the token automatically in the environment variables of postman, if not, just change it manually.

* enjoy :)

## Endpoints

* `POST /authenticate ` authentication

### Books

* `GET /books` list of books
* `GET /books/:id` a book information, limited to book fields
* `PATCH /books/:id` update a book name
* `DELETE /books/:id` delete a book from database
* `POST /books/:id` create a book

### Pages

* `POST /books/:book_id/pages` create a page for a book (page number is automatic incremental)
* `GET /books/:book_id/pages/:page_number` Fetches a page by the page number, not the ID of the page record

### Content

* `GET /pages/:page_id/contents?format=html` Returns the content html for a page, NOTE: it uses the page.id not the page_number. This is something I decided because the path would be very very long otherwise. It would also require the `book_id` and at this point you already have the page id from the page show endpoint. It can be changed though to use page number. Since I don't have any specifics on the Front end approach I did what made more sense to me.
* `POST /pages/:page_id/contents` Creates a content for a page, it requires the format and the body. Currently it will only allow HTML. 

### Steps to load a page

* `GET /books` find the book that you want
* `GET /books/:book_id/pages/:page_number` load a page from the selected book and save the page id
* `GET /pages/:page_id/contents?format=html` Load the content for that page using the id


# Resources

### User

Used for authentication

### Book

Base resource it has many pages

### Page

Belongs to a book and it has many contents, the intention was to allow different sources. One source or `Content` for each format in a page, so you could upload a PDF, HTML, XML, etc.

NOTE: files formats are not implemented yet as those were not part of the challenge. But I left a `TODO` comment where it should be added.

### Content

Source of truth for the content, it has body and file fields, you should use one or the other, not both. Each content should always have a `ContentFormat` so that it can be identified

### ContentFormat

As a kind of list, one and only one should be created for each format, in the `seeds.rb` file you can find an example of the "HTML" ContentFormat.

# Test suite

Used Rspec for test suite, just run: `rspec spec/`


