import SpriteKit
import Foundation

//postfix operator ++

postfix func ++(_ x: Int) -> Int
{
    return x + 1
}

infix operator ⊕ : AdditionPrecedence
//infix operator ⊕ { associativity left precedence 140}
func ⊕(left : [Int], right: [Int]) -> [Int]
{
    var sum = [Int](repeating: 0, count: left.count)
    assert(left.count == right.count, "vector of same length only")
    
    for (index,_) in left.enumerated()
    {
        sum[index] = left[index] + right[index]
    }
    return sum
}

func -(left : CGPoint, right : CGPoint) -> CGPoint
{
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func +(left : CGPoint, right : CGPoint) -> CGPoint
{
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func *(left : CGPoint, scalar: CGFloat) -> CGPoint
{
    return CGPoint(x: left.x * scalar, y: left.y * scalar)
}

func /(left : CGPoint, scalar : CGFloat) -> CGPoint
{
    return CGPoint(x: left.x / scalar, y: left.y / scalar)
}

extension CGPoint
{
    func length() -> CGFloat
    {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}

