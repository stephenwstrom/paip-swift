import Cocoa

// General logic and set operators

infix operator - : AdditionPrecedence

func -<X>(a: Set<X>, b: Set<X>) -> Set<X> {
    return a.subtracting(b)
}

infix operator ∪ : AdditionPrecedence

func ∪<X>(a: Set<X>, b: Set<X>) -> Set<X> {
    return a.union(b)
}

infix operator ∈ : LogicalConjunctionPrecedence

func ∈<X>(a: X, b: Set<X>) -> Bool {
    return b.contains(a)
}

infix operator ∋ : LogicalConjunctionPrecedence

func ∋<X>(a: Set<X>, b: X) -> Bool {
    return a.contains(b)
}


func forAll<X>(_ a: Set<X>) -> ((X) -> Bool) -> Bool {
    return { a.allSatisfy($0) }
}
 

func numberString(_ i: Int) -> (String) -> String {
    return { i.description + $0}
}

print(numberString(3)("Three"))


prefix operator ∀

/*
prefix func ∀<X>(_ a: Set<X>) -> ((X) -> Bool) -> Bool {
    return { a.allSatisfy($0) }
}
*/

prefix func ∀<X>(_ args: (Set<X>, (X) -> (Bool)) ) -> Bool {
    return {args.0.allSatisfy(args.1)}()
}


func isEven(n: Int) -> Bool {
    return n.isMultiple(of: 2)
}

print("all even")
print(∀([2,4,6,12],isEven))
    
infix operator ⊢ : AssignmentPrecedence

func ⊢<X>(a: Set<X>, predicate: (X) -> Bool) -> Bool {
    return a.allSatisfy(predicate)
}

// General GPS

struct Op : Hashable {
    var action: Action
    var preconds: Set<Condition>
    var addList: Set<Condition>
    var delList: Set<Condition> = []
}

var state: Set<Condition> = []

var ops: [Op] = []

func appropriateP (goal: Condition, op: Op) -> Bool {
    return goal ∈ op.addList
}

func applyOp(_ op: Op) -> Bool {
    if op.preconds ⊢ achieve {
        print("executing \(op.action)")
        state = op ∘ state
        return true
    }
    return false;
}

infix operator ∘
func ∘(op: Op, state: Set<Condition>) -> Set<Condition> {
    return state - op.delList ∪ op.addList
}


func achieve(goal: Condition) -> Bool {
    return (goal ∈ state) || (Set(ops.filter { op in goal ∈ op.addList }) ⊢ { applyOp($0) })
}

func GPS(state: Set<Condition>, goals: [Condition], ops: [Op] ) {
    if Set(goals) ⊢ achieve {
        print("solved")
    }
}

// Specific problem

enum Condition {
    case sonAtHome
    case carWorks
    case sonAtSchool
    case carNeedsBattery
    case shopKnowsProblem
    case shopHasMoney
    case inCommunicationWithShop
    case havePhoneBook
    case knowPhoneNumber
    case haveMoney
}

enum Action {
    case driveSonToSchool
    case shopInstallsBattery
    case tellShopProblem
    case telephoneShop
    case lookUpNumber
    case giveShopMoney
}

var schoolOps = [
    Op(action: .driveSonToSchool,
       preconds: [.sonAtHome, .carWorks],
       addList: [.sonAtSchool],
       delList: [.sonAtHome]),
    Op(action: .shopInstallsBattery,
       preconds: [.carNeedsBattery, .shopKnowsProblem, .shopHasMoney],
       addList: [.carWorks]),
    Op(action: .tellShopProblem,
       preconds: [.inCommunicationWithShop],
       addList: [.shopKnowsProblem]),
    Op(action: .telephoneShop,
       preconds: [.knowPhoneNumber],
       addList: [.inCommunicationWithShop]),
    Op(action: .lookUpNumber,
       preconds: [.havePhoneBook],
       addList: [.knowPhoneNumber]),
    Op(action: .giveShopMoney,
       preconds: [.haveMoney],
       addList: [.shopHasMoney],
       delList: [.haveMoney])
]

ops = schoolOps

state = [.sonAtHome, .carWorks]

GPS(state: state, goals: [ .sonAtSchool], ops: schoolOps)

print(state)


print(5.isMultiple(of: 2))

let x: Set = [2, 4, 128]

let allEven = [2, 4, 128, 365].allSatisfy({$0.isMultiple(of: 2)})


 print(allEven)


let allEven2 = [2, 4, 128, 365] ⊢ {$0.isMultiple(of: 2)}

print(allEven2)


@resultBuilder
struct GreetingBuilder {
    static func buildBlock(_ items: String...) -> [String] {
        return items.map { "Hello \($0)" }
    }
}

@GreetingBuilder func f() -> [String] {
    "Bobby"
}

f()
