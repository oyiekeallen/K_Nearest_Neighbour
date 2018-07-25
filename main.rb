=begin
    
    Allen Oyieke
    K Nearest Neighbour
    CSC 322 Machine Learning

=end

require './Algorithm/KNN_classifier'


  dataset = []
  # Read data from file
  File.open("dataset.csv", "r").each_line do |line|
    features = line.split(",") 
    dataset << features.collect(&:to_f)
  end

  
  dataset.shuffle! # Randomise dataset

  _dataset = dataset.collect{|d| c = d[0]; d[0] = d[-1]; d[-1] = c; d } #change class and the last feature

  # Separate dataset to train (70%) and predict (30%)
  taining_dataset = _dataset[0...(_dataset.size * 0.7)] # Training 70%
  prediction_dataset  = _dataset[(_dataset.size * 0.7)..-1] # Prediction 30%

  # Call algotithm (classifier)
  knn  = KNNClassifier.new(taining_dataset, {normalization: :standard_deviation})

  # Predicted values
  k=5

   
    puts "\n =======================================================================\n Begin execution\n =======================================================================\n"
    

    hits_count = []
    prediction_dataset.each do |feature_pred|
      classify = knn.classify(feature_pred, k)

      puts "\t Obtained result: #{[classify, feature_pred.last].inspect}\t Status: #{(classify == feature_pred.last ? status='[* - *] Right' : status='[_ - _] Wrong')}"

      # Hits count (correct)
      hits_count << feature_pred if(classify == feature_pred.last) 
    end

    

    # Output analysis
    puts "\n =======================================================================\n\tFor K :[#{k}]  Accuracy: #{(hits_count.size.to_f/prediction_dataset.size)*100}\n =======================================================================\n"

