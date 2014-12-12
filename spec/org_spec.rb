require_relative '../organizations'

RSpec.describe Organization do

  root_org = RootOrganization.new
  org = root_org.new_org
  child = org.new_child_org
  user_one = { name: "Colin", age: 25 }
  user_two = { name: "Sarah", age: 24 }

  context "Root Organization" do

    it "can't have two instances, like Highlander" do
      expect {RootOrganization.new}. to raise_error("There can only be one!")
    end

    it "has no parents" do
      expect {root_org.parent}.to raise_error
    end

  end

  context "Organization" do

    it "always has Root Org as parent" do
      expect(org.parent).to be(root_org)
    end

  end

  context "Child Organizations" do

    it "cannot have children" do
      expect{child.new_child_org}.to raise_error("Child organizations cannot have children")
    end

  end

  context "Permissions" do

    it "inherit for admin" do
      root_org.add_admin(user_one)
      expect(org.admin?(user_one)).to be true
      expect(child.admin?(user_one)).to be true
    end

    it "inherit for denied" do
      org.deny(user_one)
      expect(child.denied?(user_one)).to be true
    end

    it "local presence trumps inheritance" do
      org.add_admin(user_two)
      child.deny(user_two)
      expect(child.admin?(user_two)).to be false
    end

    it "does not carry over to all children" do
      child_two = org.new_child_org
      expect(child_two.denied?(user_two)).to be false
    end

  end

end
