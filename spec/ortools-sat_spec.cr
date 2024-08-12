require "./spec_helper"

describe ORTools::Sat do
  # TODO: Write tests
  #
  describe ORTools::Sat::Model do
    model = ORTools::Sat::Model.new
    bools = [model.new_bool_var, model.new_bool_var, model.new_bool_var]

    before_each do
      model = ORTools::Sat::Model.new
      bools = [model.new_bool_var, model.new_bool_var, model.new_bool_var]
    end

    describe "#add_bool_or" do
      it "should make a boolean OR constraint" do
        model.add_bool_or(bools)
        solution = model.solve
        count = bools.count { |bool| solution.true?(bool) }
        count.should be >= 1
      end
    end

    describe "#add_bool_and" do
      it "should make a boolean AND constraint" do
        model.add_bool_and(bools)
        solution = model.solve
        bools.each { |bool| solution.true?(bool).should be_true}
      end

      it "should handle negative constraints" do
        neg_bools = bools.map { |bool| -bool }
        model.add_bool_and(neg_bools)
        solution = model.solve
        bools.each { |bool| solution.true?(bool).should be_false}
      end
    end

    describe "#add_bool_xor" do
      it "should make a boolean XOR constraint" do
        model.add_bool_xor(bools)
        solution = model.solve
        count = bools.count { |bool| solution.true?(bool) }
        count.odd?.should be_true
      end
    end

    describe "#minimize" do
      it "should minimize the sum of a list of variables" do
        int_vars = [model.new_int_var(0, 10), model.new_int_var(3, 10), model.new_int_var(5, 10)]
        model.minimize(int_vars.sum)
        solution = model.solve
        solution.solved?.should be_true
        int_vars.sum { |int_var| solution.value(int_var) }.should eq 8
      end
    end

    describe "Linear Constraint" do
      it "should correctly constrain the solution" do
        higher = model.new_int_var(0,5)
        lower = model.new_int_var(4,10)
        model.add_constraint(higher > lower)
        solution = model.solve
        solution.solved?.should be_true
        solution.value(higher).should eq 5
        solution.value(lower).should eq 4
      end
    end
  end
end
