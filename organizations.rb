# Organizations are created from the root organization, child organizations are
# created from organizations

class RootOrganization

  @@root_count = 0

  attr_accessor :children, :denied

  attr_reader :admins, :denied, :users

  def self.singleton_tracker
    raise "There can only be one!" if @@root_count > 0
    @@root_count += 1
  end

  def initialize
    @children = []
    @admins = []
    @denied = []
    RootOrganization.singleton_tracker
  end

  def admin?(user)
    @admins.include?(user)
  end

  def denied?(user)
    @denied.include?(user)
  end

  def add_admin(user)
    if self.denied?(user)
      raise "User has been denied"
    else
      @admins << user unless self.admin?(user)
    end
  end

  def deny(user)
    @denied << user unless @denied.include?(user)
  end

  def new_org
    child = Organization.new(self)
    @children << child
    child
  end

end


class Organization < RootOrganization

  attr_reader :parent

  def initialize(parent)
    @children = []
    @admins = []
    @denied = []
    @parent = parent
  end

  def denied?(user)
    @denied.include?(user) || self.parent.denied?(user)
  end

  def admin?(user)
    if self.denied?(user)
      return false
    else
      @admins.include?(user) || self.parent.admin?(user)
    end
  end

  def new_org
    raise "Organizations can only create child organizations"
  end

  def new_child_org
    child = ChildOrganization.new(self)
    @children << child
    child
  end

end


class ChildOrganization < Organization

  def initialize(parent)
    super(parent)
    @children = nil
  end

  def new_org
    raise "Child organizations cannot have children"
  end

  def new_child_org
    raise "Child organizations cannot have children"
  end

end
