FactoryGirl.define do
  factory :user do
    username "Pekka"
    password "foobar1"
    password_confirmation "foobar1"
  end

  factory :brewery do
    name "anonymous"
    year 1900
  end

  factory :brewery2, :class => Brewery do
    name "supernymous"
    year 1990
  end

  factory :style do
    name "Lager"
    desc "Pretty stylish style yo"
  end

  factory :beer do
    name "anonymous"
    brewery
    style "Lager"
  end

  factory :beer2, :class => Beer do
    name "superiore"
    brewery
    style "Super"
  end

  factory :rating, :class => Rating do
    score 10
    beer_id 1
  end

  factory :rating2, :class => Rating do
    score 20
    beer_id 1
  end

  factory :rating3, :class => Rating do
    score 30
    beer_id 2
  end
end