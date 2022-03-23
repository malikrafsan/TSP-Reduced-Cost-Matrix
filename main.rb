# Author
# Malik Akbar Hashemi Rafsanjani
# 1352015

INF = Float::INFINITY
$firstNode = -1

class PriorityQueueNode
  def initialize
    @elements = []
  end

  def <<(element)
    @elements << element
    @elements.sort_by! { |node| node.cost }
  end

  def pop
    @elements.delete_at(0)
  end

  def top
    return @elements[0]
  end

  def describe
    @elements.each do |element|
      puts "============================="
      displayNode(element)
      puts "============================="
    end
  end

  def size
    return @elements.length
  end
end

class Node
  attr_accessor :matrix, :path, :cost, :vertex, :i, :j, :level
end

class Pair
  attr_reader :first, :second

  def initialize(first, second)
    @first = first
    @second = second
  end
end

def copyMatrix(matrix)
  newMatrix = []
  matrix.each do |row|
    newLine = []
    row.each do |element|
      newLine << element
    end
    newMatrix << newLine
  end

  return newMatrix
end

def copyPath(path)
  newPath = []
  path.each do |pair|
    newPath << pair
  end
  return newPath
end

def newNode(matrix, path, level, i, j)
  node = Node.new
  node.path = copyPath(path)
  if (level != 0)
    node.path << Pair.new(i, j)
  end

  node.matrix = copyMatrix(matrix)

  if (level != 0)
    for k in 0..matrix.length - 1
      node.matrix[i][k] = INF
      node.matrix[k][j] = INF
    end
  end

  node.matrix[j][$firstNode] = INF
  node.level = level
  node.vertex = j
  return node
end

def calcCost(matrix)
  cost = 0
  rowMin = Array.new(matrix.length, INF)
  colMin = Array.new(matrix.length, INF)

  for i in 0..matrix.length-1
    for j in 0..matrix.length-1
      if (matrix[i][j] < rowMin[i])
        rowMin[i] = matrix[i][j]
      end
    end
  end

  for i in 0..matrix.length-1
    for j in 0..matrix.length-1
      if (matrix[i][j] != INF && rowMin[i] != INF)
        matrix[i][j] -= rowMin[i]
      end
    end
  end

  for i in 0..matrix.length-1
    for j in 0..matrix.length-1
      if (matrix[i][j] < colMin[j])
        colMin[j] = matrix[i][j]
      end
    end
  end

  for i in 0..matrix.length-1
    for j in 0..matrix.length-1
      if (matrix[i][j] != INF && colMin[j] != INF)
        matrix[i][j] -= colMin[j]
      end
    end
  end

  for i in 0..matrix.length-1
    cost += (rowMin[i] != INF) ? rowMin[i] : 0
    cost += (colMin[i] != INF) ? colMin[i] : 0
  end

  return cost
end

def printMatrix(matrix)
  matrix.each do |row|
    row.each do |element|
      print (element == INF) ? "INF " : "#{element} "
    end
    puts
  end
end

def printPath(path)
  puts "PATH:"
  path.each do |pair|
    puts "#{pair.first + 1} -> #{pair.second + 1}"
  end
end

def displayNode(node)
  puts "============================="
  printPath(node.path)
  puts "Cost: #{node.cost}"
  puts "Level: #{node.level}"
  puts "Matrix:"
  printMatrix(node.matrix)
  puts "============================="
end

def solve(matrix)
  # initialize priority queue and root node
  pq = PriorityQueueNode.new
  root = newNode(matrix, [], 0, -1, $firstNode)
  root.cost = calcCost(root.matrix)
  pq << root

  while (pq.size > 0)
    # get minimum node
    min = pq.top
    pq.pop

    i = min.vertex
    # check if it is the last node
    if (min.level == matrix.length - 1)
      min.path << Pair.new(i, $firstNode)

      # display result
      printPath(min.path)
      puts "Cost: #{min.cost}"
      
      # prune the tree automatically by stopping the search
      return
    end

    # get the child nodes
    for j in 0..matrix.length-1
      if (min.matrix[i][j] != INF)
        newNode = newNode(min.matrix, min.path, min.level + 1, i, j)
        newNode.cost = min.cost + min.matrix[i][j] + calcCost(newNode.matrix)
        pq << newNode
      end
    end
  end
end

def readFile(path)
  file = File.open(path)
  file_data = file.read
  file_data = file_data.split("\n")
  return file_data
end

def initMatrix(arrStr)
  matrix = []
  arrStr.each do |line|
    arr = []
    line.split(" ").each do |x|
      arr << (x == "INF" ? INF : x.to_i)
    end
    matrix << arr
  end

  return matrix
end

def getFirstNode(n)
  while true
    print "Enter the starting node: "
    firstNode = gets.to_i
    if (firstNode <= n && firstNode > 0)
      break
    end
    puts "Start Node is not valid"
  end

  return firstNode-1
end

def getTestCase
  while true
    print "Enter the number of test file on tests folder (number only): "
    testCase = gets.to_i
    if (testCase >= 1 && testCase <= 4)
      break
    end
    puts "Test case is not valid. Please insert number only"
  end

  return testCase
end

def main
  # main program

  idx = getTestCase
  data = readFile("tests/" + idx.to_s + ".txt")

  # parse array of string to matrix
  matrix = initMatrix(data)
  puts "Matrix test case: "
  printMatrix(matrix)

  $firstNode = getFirstNode(matrix.length)
  solve(matrix)
end

# Run main program
main