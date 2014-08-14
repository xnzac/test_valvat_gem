require 'spec_helper'

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

describe Eurovat do

  let!(:eurovat) { Eurovat.new }

  context "valid VAT numbers" do

    VALID_VAT_NUMBERS.each do |vat_number|
      it "#{vat_number} is valid" do
        expect(eurovat.check_vat_number(vat_number)).to be_eql true
      end
    end

  end

  context "invalid VAT numbers" do

  end

end