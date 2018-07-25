require 'descriptive_statistics' #used for mean , standard deviation and other mathematical function.

class KNNClassifier

  attr_reader :dataset, :dataset_normalized

  <<-DOC
    Exepcted dataset format
    dataset = [[featureA, featureB,..., featureN, "classX"],...,...,]
    DOC
  
 
  def initialize(dataset = [], options = {})
    <<-DOC
    Function to initialize dataset
    Parameters include :
        dataset
        options
    DOC

    @dataset            = dataset
    @dataset_normalized = []

    @normalization      = options[:normalization] || :none # linear or standard_deviation

    normalize()
    
  end

  
  def classify(attributes, k = 3)
      <<-DOC
      This method classify the attributes, and return the class
    K is assumed by default as 3
      DOC
      
    feature_normalized = get_attributes_normalized(attributes)
    
    res = @dataset_normalized.sort_by do |attributes_ds|
      distance(attributes_ds, feature_normalized)
    end

    # Obtain the class of neighbours
    res[0...k].collect{|n| n.last }.mode
    
  end  


  def distance(attribute1, attribute2, type = :euclidian)
      <<-DOC
      Returns the distance of the characteristics between two objects ( for equilidian distance)
      DOC
      
    sum = 0
    count_attributes.times do |i|
      sum += (attribute1[i] - attribute2[i])**2
    end

    Math::sqrt(sum)
    
  end

  def count_attributes
    @dataset.first.size - 1
  end

  private 

  
  def normalize()
      <<-DOC
      Normalize dataset 
      DOC
    @dataset.each do |attributes|
      feature_normalized = get_attributes_normalized(attributes)

      # Add class
      feature_normalized[count_attributes] = attributes.last

      @dataset_normalized << feature_normalized
    end
  end

  def get_attributes_normalized(attributes)
      <<-DOC
      Get attributes 
      DOC
      
    case @normalization
      when :linear
        normalize_linear(attributes)
      when :standard_deviation
        normalize_sd(attributes)
      when :none
        attributes
      else
        raise "Normalization not found"
      end
  end
  
  
  def normalize_linear(attributes)
      <<-DOC
      Normalize dataset with a Normalization by Linear [min, max, mean, sd]
      DOC
      
    statistics = get_statistics_of_attributes
    n_attributes = []

    count_attributes.times do |fi|
      min, max, mean, sd = statistics[fi]
      n_attributes[fi] = (attributes[fi]-min).to_f/(max-min)
    end

    n_attributes
  end


  def normalize_sd(attributes)
    <<-DOC
    Normalize dataset with a Normalization by standard deviation [min, max, mean, sd]
    DOC
    
    statistics = get_statistics_of_attributes
    n_attributes = []
    
    count_attributes.times do |fi|
      min, max, mean, sd = statistics[fi]
      n_attributes[fi] = (attributes[fi]-mean).to_f/(sd)
    end

    n_attributes
  end


  def get_statistics_of_attributes
    <<-DOC
    Return the statistics of all attributes (min, max, mean, sd)
    DOC
    return  @statistics if  not @statistics.nil?

    # Statistics of attributes (min, max, mean, sd)
    @statistics  = []

    count_attributes.times do |i|
      f_min, f_max, f_mean, f_std = statistics_of_attributes(i)

      @statistics[i] = [f_min, f_max, f_mean, f_std]
    end

    @statistics
  end


  def statistics_of_attributes(index)
    <<-DOC
       Return the statistics of feature format (min, max, mean, sd)
    DOC
    attributes_of_class = @dataset.collect{|d| d[index]}
   
    return [attributes_of_class.min, attributes_of_class.max, attributes_of_class.mean, attributes_of_class.standard_deviation]
    
  end
end
