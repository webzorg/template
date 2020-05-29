FactoryBot.define do
  names = %w[Almond Apple Apricot Pear Cherry Damson Fig Hazel
             Medlar Mirabelle Mulberry Nectarine Peach Plum Walnut]

  factory :tree do
    title { names.sample }
    content { "MyText" }
    toggler { false }
  end
end
