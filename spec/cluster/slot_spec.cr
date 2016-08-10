require "./spec_helper"

describe Redis::Cluster::Slot do
  describe ".parse" do
    it "should convert '1234' to set" do
      Redis::Cluster::Slot.parse("1234").set.should eq Set{1234}
    end

    it "should convert '1234..1235' to set" do
      Redis::Cluster::Slot.parse("1234..1235").set.should eq Set{1234, 1235}
    end

    it "should convert '1234-1235' to set" do
      Redis::Cluster::Slot.parse("1234-1235").set.should eq Set{1234, 1235}
    end

    it "should convert '..2' to 0 origin set" do
      Redis::Cluster::Slot.parse("..2").set.should eq (0..2).to_set
    end

    it "should convert '-2' to 0 origin set" do
      Redis::Cluster::Slot.parse("-2").set.should eq (0..2).to_set
    end

    it "should convert '16300..' to 16383-ended set" do
      Redis::Cluster::Slot.parse("16300..").set.should eq (16300..16383).to_set
    end

    it "should convert '16300-' to 16383-ended set" do
      Redis::Cluster::Slot.parse("16300-").set.should eq (16300..16383).to_set
    end

    it "should treat ',' or ' ' as a multiple requests" do
      slot = Redis::Cluster::Slot.parse("..3 10,20..21 30-32,16380..")
      slot.set.should eq Set{0, 1, 2, 3, 10, 20, 21, 30, 31, 32, 16380, 16381, 16382, 16383}
    end
  end

  describe ".slot" do
    it "calculate slot" do
      Redis::Cluster::Slot.slot("1234").should eq(6025)
      Redis::Cluster::Slot.slot("3194").should eq(3194)
    end

    it "calculate slot with hash tags" do
      Redis::Cluster::Slot.slot("{3194}{").should eq(3194)
      Redis::Cluster::Slot.slot("x{3194}}}").should eq(3194)
      Redis::Cluster::Slot.slot("x{3194}y{a}").should eq(3194)

      Redis::Cluster::Slot.slot("3{194").should eq(1305)
      Redis::Cluster::Slot.slot("x{3{194}y{a}").should eq(1305)
      
      Redis::Cluster::Slot.slot("3{19").should eq(3602)
      Redis::Cluster::Slot.slot("x{3{19}4}y{a}").should eq(3602)

      Redis::Cluster::Slot.slot("{3194").should eq(15619)
      Redis::Cluster::Slot.slot("x{3194").should eq(13789)
      Redis::Cluster::Slot.slot("}{{").should eq(262)
    end
  end
end
