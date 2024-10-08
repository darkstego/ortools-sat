require "./spec_helper"
module ORTools::Sat

  describe Model do
    model = Model.new
    bools = [model.new_bool_var, model.new_bool_var, model.new_bool_var]

    before_each do
      model = Model.new
      bools = [model.new_bool_var, model.new_bool_var, model.new_bool_var]
    end

    describe "#add_bool_or" do
      it "should make a boolean OR constraint" do
        model.add_bool_or(bools)
        solution = model.solve
        solution.should be_a ValidSolution
        next unless solution.is_a? ValidSolution
        count = bools.count { |bool| solution.true?(bool) }
        count.should be >= 1
      end
    end

    describe "#add_bool_and" do
      it "should make a boolean AND constraint" do
        model.add_bool_and(bools)
        solution = model.solve
        solution.should be_a ValidSolution
        next unless solution.is_a? ValidSolution
        bools.each { |bool| solution.true?(bool).should be_true}
      end

      it "should handle negative constraints" do
        neg_bools = bools.map { |bool| -bool }
        model.add_bool_and(neg_bools)
        solution = model.solve
        solution.should be_a ValidSolution
        next unless solution.is_a? ValidSolution
        bools.each { |bool| solution.true?(bool).should be_false}
      end
    end

    describe "#add_bool_xor" do
      it "should make a boolean XOR constraint" do
        model.add_bool_xor(bools)
        solution = model.solve
        solution.should be_a ValidSolution
        next unless solution.is_a? ValidSolution
        count = bools.count { |bool| solution.true?(bool) }
        count.odd?.should be_true
      end
    end

    describe "#minimize" do
      it "should minimize the sum of a list of variables" do
        int_vars = [model.new_int_var(0, 10), model.new_int_var(3, 10), model.new_int_var(5, 10)]
        model.minimize(int_vars.sum)
        solution = model.solve
        solution.should be_a ValidSolution
        next unless solution.is_a? ValidSolution
        solution.valid?.should be_true
        int_vars.sum { |int_var| solution.value(int_var) }.should eq 8
      end
    end

    describe "Linear Constraint" do
      it "should correctly constrain the solution" do
        higher = model.new_int_var(0,5)
        lower = model.new_int_var(4,10)
        model.add_constraint(higher > lower)
        solution = model.solve
        solution.should be_a ValidSolution
        next unless solution.is_a? ValidSolution
        solution.valid?.should be_true
        solution.value(higher).should eq 5
        solution.value(lower).should eq 4
      end
    end

    describe "Sum Comstraints" do
      it "should correctly equal the sum of an array" do
        a = model.new_int_var(-100,100)
        arr = [10.to_lexpr, -5, 20]
        model.add_constraint(a == arr.sum)
        solution = model.solve
        solution.should be_a ValidSolution
        next unless solution.is_a? ValidSolution
        solution.value(a).should eq 25
      end
    end

    describe "No Solution" do
      it "valid? should return false when no solution is viable" do
        a = model.new_int_var(0,3)
        b = model.new_int_var(5,8)
        model.add_constraint a > b
        solution = model.solve
        solution.valid?.should be_false
      end
    end

    describe "Valid Solution" do
      it "should be of ValidSolution class when solution is viable" do
        a = model.new_int_var(0,3)
        b = model.new_int_var(5,8)
        model.add_constraint a < b
        solution = model.solve
        solution.should be_a ValidSolution
      end
    end

    describe "Set Variable to Max/min" do
      it "should set variable to max" do
        a = model.new_int_var(0,100)
        arr = [5,23,10,11]
        model.add_max(a,arr)
        solution = model.solve
        solution.should be_a ValidSolution
        next unless solution.is_a? ValidSolution
        solution.value(a).should eq 23
      end

      it "should set variable to min" do
        a = model.new_int_var(0,100)
        arr = [5,23,10,11]
        model.add_min(a,arr)
        solution = model.solve
        solution.should be_a ValidSolution
        next unless solution.is_a? ValidSolution
        solution.value(a).should eq 5
      end
    end

    describe "minimize objective" do
      it "should handle simple examples" do
        a = model.new_int_var(1,4)
        b = model.new_int_var(1,4)
        c = model.new_int_var(1,4)
        model.add_all_diff([a,b,c])
        model.minimize b.to_lexpr
        solution = model.solve
        solution.should be_a ValidSolution
        next unless solution.is_a? ValidSolution
        solution.value(b).should eq 1
        solution.objective_value.should eq 1
      end
    end

    describe "Set Variable to And" do
      it "bool should control all variables" do
        arr = (0...3).map {|i| model.new_bool_var}
        bool = model.new_bool_var
        model.add_constraint (bool == 1)
        model.set_to_bool_and(bool,arr)
        model.minimize arr.sum
        solution = model.solve
        solution.should be_a ValidSolution
        next unless solution.is_a? ValidSolution
        solution.true?(bool).should be_true
        arr.each {|bv| solution.true?(bv).should be_true}
      end

      it "should not find solution if bool can't control all variables" do
        arr = (0...3).map {|i| model.new_bool_var}
        bool = model.new_bool_var
        model.add_constraint(bool == 1)
        model.add_constraint(arr.first == 0)
        model.set_to_bool_and(bool,arr)
        solution = model.solve
        solution.valid?.should be_false
      end

      it "variables should control bool" do
        arr = (0...3).map {|i| model.new_bool_var}
        bool = model.new_bool_var
        arr.each {|bv| model.add_constraint(bv==1)}
        model.set_to_bool_and(bool,arr)
        model.minimize bool.to_lexpr
        solution = model.solve
        solution.should be_a ValidSolution
        next unless solution.is_a? ValidSolution
        solution.true?(bool).should be_true
        arr.each {|bv| solution.true?(bv).should be_true}
      end

      it "should not find solution if variables can't control bool" do
        arr = (0...3).map {|i| model.new_bool_var}
        bool = model.new_bool_var
        model.add_constraint(arr.first == 0)
        model.add_constraint(bool == 1)
        model.set_to_bool_and(bool,arr)
        solution = model.solve
        solution.valid?.should be_false
      end

      it "should not find solution if variables can't control bool" do
        arr = (0...3).map {|i| model.new_bool_var}
        bool = model.new_bool_var
        arr.map! {|b| -b}
        model.set_to_bool_and(bool,arr)
        model.add_constraint(bool == 1)
        solution = model.solve
        solution.valid?.should be_true
      end

    end
  end
end
