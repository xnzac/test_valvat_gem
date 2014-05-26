require 'spec_helper'
if defined?(ModelBase)
  class Invoice < ModelBase
    validates :vat_number, :valvat => true
  end

  class TestAllowBlank < ModelBase
    validates :vat_number, :valvat => {:allow_blank => true}
  end

  class TestMatchCountry < ModelBase
    validates :vat_number, :valvat => {:match_country => :country}
    def country
      @attributes[:country]
    end
  end

end

VALID_VAT_NUMBERS = %w(
  ATU15138205 ATU46080404 ATU61195628 BE0453521619 BE0474840437 BG130544585
  BG130736984 CZ26780259 CZ49620819 DE112144487 DE119817125 DK10290813
  DK18661306 DK21832073 DK26210895 EE100878938 EE100919295 EL094501040
  EL095723304 ESA78109592 ESA79220109 ESB80067358 ESG0061466I FI04695196
  FI15408594 FR01712030113 FR64333266765 FR84350934675 FR95483929956
  gb123456789 GB123456789012 GB195275334 GB642423951 GB750323267 GB759713196
  GB987654321 gbGD123 gbHA456 HU10268492 HU12078503 IE9507061A IE9Y71814N
  IT00743110157 IT02087050155 IT08041000012 IT11492960155 LT100002894215
  LT290068995116 LU15027442 LU21416127 LV40003638595 LV50003087101
  MT15220517 MT17365728 NL001545668B01 NL008810151B01 PL5260000821
  PL5261025421 PL6772135826 PT501301135 PT503038083 RO16241790 RO2413020
  SE502052817901 SE556043606401 SE556229159001 SI37568833 SI97093726
  SK2020133082 SK2020349045
  CY12345678A CY87654321Z
  EU123456789 EU987654321
) +
[
  'GB987 6543 21', 'GB842 0753 41', 'gb123 4567 89', 'DK99 99 99 99',
  'FR99 123456789'
]

INVALID_VAT_PICTURES = %w(
  gb1234567890 gb12345678
  ATu12345678 ATX12345678 ATU1234567 ATU123456789 ATU1234A678
  BE413562567 BE1123456789 BE012345678 BE01234567890 BE01234A6789
  BG12345678 BG12345678901 BGA123456789 BG01234A6789
  CY1234567X CY123456789X CY123456789 CY12345678j CYA2345678X CY1234567AX
  CZ1234567 CZ12345678901 CZ1234A678 CZA23456789 CZ12345678A
  DE12345678 DE1234567890 DEA23456789 DE12345678A
  DK1234567 DK123456789 DKA2345678 DK1234567A
  EE12345678 EE1234567890 EEA23456789 EE12345678A
  EL12345678 EL1234567890 ELA23456789 EL12345678A
  ESAA234567A ESA123456AA ESa1234567a ESA123456A ESA1234567 ESA12345678A
  ESA123456789 ES1234567890
  EU12345678 EU1234567890 EUA23456789 EU12345678A
  FI1234567 FI123456789 FIA2345678 FI1234567Z
  FRIX123456789 FROX123456789 FRXI123456789 FRXO123456789
  FR0012345678 FRAA1234567890 FR01234567890A FRAAA23456789
  FRaa123456789
  gb12345678 gb1234567890 gbA23456789 gb12345678A
  gb12345678901 gb1234567890123 gb12345678901A gbA23456789012
  GBHA12 GBHA1234 GBHAA23 GBHA12A
  GBGD12 GBGD1234 GBGDA23 GBGD12A gbXX123
  HU1234567 HU123456789 HUA2345678 HU1234567Z
  IE9X123456A IE9X1234A IE6X12345A IEA123456A IE9+12345X
  IE9X123456 IE9a12345A IE9X12345a
  IT1234567890 IT123456789012 ITA2345678901 IT1234567890A
  LT12345678 LT1234567890 LT12345678901 LT1234567890123
  LTA12345678 LT12345678A LTA12345678901 LT12345678901A
  LU1234567 LU123456789 LUA2345678 LU1234567Z
  LV1234567890 LV123456789012 LVA2345678901 LV1234567890A
  MT1234567 MT123456789 MTA2345678 MT1234567Z
  NL12345678B12 NL1234567890B12 NL123456789B1 NL123456789B123
  NL123456789012 NLA23456789B12 NL12345678AB12 NL123456789BA2
  NL123456789B1A NL123456789A12 NL123456789C12
  PL123456789 PL12345678901 PLA234567890 PL123456789A
  PT12345678 PT1234567890 PTA23456789 PT12345678A
  RO1 RO12345678901 ROAA ROA234567890 RO123456789A
  SE12345678901 SE1234567890123 SEA23456789012 SE12345678901A
  SI1234567 SI123456789 SIA2345678 SI1234567Z
  SK123456789 SK12345678901 SKA234567890 SK123456789A
) + [
  'GB98 765 423 1', 'gb987654321 0', 'DK99 99 99 99 99', 'DK99 99 99'
]

describe Invoice do
  context "with valid vat number" do
    it "should be valid" do
      Invoice.new(:vat_number => "DE259597697").should be_valid
    end

    VALID_VAT_NUMBERS.each do |vat_number|
      it "#{vat_number} should be valid vat number" do
        Invoice.new(:vat_number => vat_number).should be_valid
      end

      it "#{vat_number} is provided as vat_number and country code #{vat_number[0..1]}" do
        temp = Invoice.new(:vat_number => vat_number, :country => vat_number[0..1])
        temp.should be_valid
      end
    end

  end

  context "with invalid vat number" do
    let(:invoice) { Invoice.new(:vat_number => "DE259597697123") }

    it "should not be valid" do
      invoice.should_not be_valid
    end

    it "should add default (country specific) error message" do
      invoice.valid?
      invoice.errors[:vat_number].should eq(["is not a valid German vat number"])
    end

    INVALID_VAT_PICTURES.each do |vat_number|
      it "#{vat_number} should not be valid vat number" do
        Invoice.new(:vat_number => vat_number).should_not be_valid
      end
    end
  end

 context "with blank vat number" do
    it "should not be valid" do
      Invoice.new(:vat_number => "").should_not be_valid
      Invoice.new(:vat_number => nil).should_not be_valid
    end
  end
end

describe TestAllowBlank do
 context "with blank vat number" do
    it "should be valid" do
      TestAllowBlank.new(:vat_number => "").should be_valid
      TestAllowBlank.new(:vat_number => nil).should be_valid
    end
  end
end

describe TestMatchCountry do
  it "should be not valid on blank country" do
    TestMatchCountry.new(:country => nil, :vat_number => "DE259597697").should_not be_valid
    TestMatchCountry.new(:country => "", :vat_number => "DE259597697").should_not be_valid
  end

  it "should be valid on matching country" do
    TestMatchCountry.new(:country => "DE", :vat_number => "DE259597697").should be_valid
    TestMatchCountry.new(:country => "AT", :vat_number => "ATU65931334").should be_valid
  end

  it "should be not valid on mismatching (eu) country" do
    TestMatchCountry.new(:country => "FR", :vat_number => "DE259597697").should_not be_valid
    TestMatchCountry.new(:country => "AT", :vat_number => "DE259597697").should_not be_valid
    TestMatchCountry.new(:country => "DE", :vat_number => "ATU65931334").should_not be_valid
  end

  it "should give back error message with country from :country_match" do
    invoice = TestMatchCountry.new(:country => "FR", :vat_number => "DE259597697")
    invoice.valid?
    invoice.errors[:vat_number].should eql(["is not a valid French vat number"])
  end

  it "should give back error message with country from :country_match even on invalid vat number" do
    invoice = TestMatchCountry.new(:country => "FR", :vat_number => "DE259597697123")
    invoice.valid?
    invoice.errors[:vat_number].should eql(["is not a valid French vat number"])
  end

end
