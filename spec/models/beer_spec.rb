require 'spec_helper'

describe Beer do

  it "should not be created without a name" do
    birra = Beer.create :styles => "Bad Mojo"

    expect(birra.valid?).to be(false)
    expect(Beer.count).to be(0)
  end

  it "no beer should have no style, for reals yo" do
      no_style = Beer.create :name => "McCool"
      expect(no_style.valid?).to be(false)
      expect(Beer.count).to be(0)
  end

end
