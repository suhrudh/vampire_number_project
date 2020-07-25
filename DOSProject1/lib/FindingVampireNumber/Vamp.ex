defmodule FindingVampireNumber.Vamp do

  def checkNumLen(num) do
    cond do
      rem(length(Integer.digits(num)),2) == 1 -> false
      rem(length(Integer.digits(num)),2) == 0 -> true
      true -> false
    end
  end


  def findFangs(num,startLen,endLen,digSort,digLength) do
      oneFangList = Enum.filter(startLen..endLen, fn x -> fangCriteria(x,num,digLength,digSort) end)
      if(length(oneFangList)>0) do

        fangList=Enum.map(oneFangList, fn x -> [x,div(num, x)] end)
        output = [ num | fangList ]
        List.flatten(output)
      end

  end

  def fangCriteria(val,num,digLength,digSort) do
    remainder = rem(num,val) == 0
    cond do
      remainder -> checkFangLen(val,num,digLength,digSort)
      true -> false
    end
  end

  def checkFangLen(val,num,digLength,digSort) do
    rightHalf=length(Integer.digits(div(num,val))) == div(digLength,2)
    leftHalf=length(Integer.digits(val)) == div(digLength,2)
    numFangDigits = rightHalf and leftHalf
    cond do
      numFangDigits -> checkFangPermutation(val,div(num,val),digSort)
      true -> false
    end

  end

  def checkFangPermutation(firstVal,secondVal,digSort) do
    fangStr=Enum.join((Enum.sort(String.codepoints(Enum.join([firstVal,secondVal],"")))),"")
    fangPerm= fangStr == digSort
    lastDigCheck = rem(firstVal,10) ==0 and rem(secondVal,10)==0
    cond do
      fangPerm and !lastDigCheck -> true
      true -> false
    end
  end

  def start(input) do
    n = trunc(input)
    digSort=Enum.join(Enum.sort(Integer.digits(n)),"")
    digLength=length(Integer.digits(n))
    divisor = :math.pow(10,div(length(Integer.digits(n)),2)) |> round
    startLen =  div(n,divisor)
    endLen = :math.sqrt(n) |> round

    if(checkNumLen(n)==true) do
      findFangs(n,startLen,endLen,digSort,digLength)
    end
  end

end
