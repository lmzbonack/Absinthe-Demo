defmodule Tc.Factory do
  use ExMachina.Ecto, repo: Tc.Repo

  def user_factory do
    %Tc.Accounts.User{
      name: Faker.Person.name(),
      email: Faker.Internet.email(),
      password: "password",
      password_hash: Bcrypt.hash_pwd_salt("password")
    }
  end

  def library_factory do
    %Tc.Libraries.Library{
      name: Faker.Lorem.Shakespeare.hamlet,
      address: Faker.Address.En.street_address()
    }
  end

  def book_factory do
    %Tc.Books.Book{
      name: Faker.Lorem.sentence(),
      library: build(:library)
    }
  end
end
