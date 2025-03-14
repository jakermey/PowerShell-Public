$theaters = for ( $theaterNumber = 1 ; $theaterNumber -le 6 ; $theaterNumber++ ) {
	[PSCustomObject]@{
		ID = (New-Guid).Guid
		TheaterNumber = $theaterNumber
		TheaterName = switch ($theaterNumber % 2) {
			'0' { "Python Playhouses" }
			'1' { "TypeScript Theaters" }
		}
		Location = switch ($theaterNumber % 3) {
			'0' { "Santa Monica" }
			'1' { "Pasadena" }
			'2' { "Long Beach" }
		}
	}
} 
$theaters
$theaters | Export-Csv ".\Theaters.csv"

$movies = for ( $movieNumber = 1 ; $movieNumber -le 6 ; $movieNumber++ ) {
	[PSCustomObject]@{
		ID = (New-Guid).Guid
		MovieNumber = $movieNumber
		MovieName = ""
	}
} 
$movies[0].MovieName = "Heat"
$movies[1].MovieName = "Pulp Fiction"
$movies[2].MovieName = "Snow White & The Seven Dwarfs"
$movies[3].MovieName = "Frozen"
$movies[4].MovieName = "Anchorman: The Legend of Ron Burgandy"
$movies[5].MovieName = "Remember The Titans"
$movies
$movies | Export-Csv ".\Movies.csv"

$customers = for ( $customerNumber = 1 ; $customerNumber -le 5000 ; $customerNumber++ ) {
	[PSCustomObject]@{
		ID = (New-Guid).Guid
		CustomerNumber = $customerNumber
		FirstName = ( Get-Random -InputObject ( "James", "John", "Robert", "Michael", "William", "David", "Richard", "Charles", "Joseph", "Thomas", "Christopher", "Daniel", "Paul", "Mark", "George", "Steven", "Edward", "Brian", "Ronald", "Anthony", "Kevin", "Jason", "Matthew", "Gary", "Timothy", "Jose", "Larry", "Jeffrey", "Frank", "Scott", "Eric", "Stephen", "Andrew", "Raymond", "Gregory", "Joshua", "Jerry", "Dennis", "Walter", "Patrick", "Peter", "Harold", "Douglas", "Henry", "Carl", "Arthur", "Ryan", "Roger", "Joe", "Juan", "Jack", "Albert", "Jonathan", "Justin", "Terry", "Gerald", "Keith", "Samuel", "Willie", "Ralph", "Lawrence", "Nicholas", "Roy", "Benjamin", "Bruce", "Brandon", "Adam", "Harry", "Fred", "Wayne", "Billy", "Steve", "Louis", "Jeremy", "Aaron", "Randy", "Howard", "Eugene", "Carlos", "Russell", "Bobby", "Victor", "Martin", "Ernest", "Phillip", "Todd", "Jesse", "Craig", "Alan", "Shawn", "Clarence", "Sean", "Philip", "Chris", "Johnny", "Earl", "Jimmy", "Antonio", "Danny", "Mary", "Patricia", "Linda", "Barbara", "Elizabeth", "Jennifer", "Maria", "Susan", "Margaret", "Dorothy", "Lisa", "Nancy", "Karen", "Betty", "Helen", "Sandra", "Donna", "Carol", "Ruth", "Sharon", "Michelle", "Laura", "Sarah", "Kimberly", "Deborah", "Jessica", "Shirley", "Cynthia", "Angela", "Melissa", "Brenda", "Amy", "Anna", "Rebecca", "Virginia", "Kathleen", "Pamela", "Martha", "Debra", "Amanda", "Stephanie", "Carolyn", "Christine", "Marie", "Janet", "Catherine", "Frances", "Ann", "Joyce", "Diane", "Alice", "Julie", "Heather", "Teresa", "Doris", "Gloria", "Evelyn", "Jean", "Cheryl", "Mildred", "Katherine", "Joan", "Ashley", "Judith", "Rose", "Janice", "Kelly", "Nicole", "Judy", "Christina", "Kathy", "Theresa", "Beverly", "Denise", "Tammy", "Irene", "Jane", "Lori", "Rachel", "Marilyn", "Andrea", "Kathryn", "Louise", "Sara", "Anne", "Jacqueline", "Wanda", "Bonnie", "Julia", "Ruby", "Lois", "Tina", "Phyllis", "Norma", "Paula", "Diana", "Annie", "Lillian", "Emily" ) )
		LastName = ( Get-Random -InputObject ( "Smith", "Johnson", "Williams", "Brown", "Jones", "Garcia", "Miller", "Davis", "Rodriguez", "Martinez", "Hernandez", "Lopez", "Gonzalez", "Wilson", "Anderson", "Thomas", "Taylor", "Moore", "Jackson", "Martin", "Lee", "Perez", "Thompson", "White", "Harris", "Sanchez", "Clark", "Ramirez", "Lewis", "Robinson", "Walker", "Young", "Allen", "King", "Wright", "Scott", "Torres", "Nguyen", "Hill", "Flores", "Green", "Adams", "Nelson", "Baker", "Hall", "Rivera", "Campbell", "Mitchell", "Carter", "Roberts", "Gomez", "Phillips", "Evans", "Turner", "Diaz", "Parker", "Cruz", "Edwards", "Collins", "Reyes", "Stewart", "Morris", "Morales", "Murphy", "Cook", "Rogers", "Gutierrez", "Ortiz", "Morgan", "Cooper", "Peterson", "Bailey", "Reed", "Kelly", "Howard", "Ramos", "Kim", "Cox", "Ward", "Richardson", "Watson", "Brooks", "Chavez", "Wood", "James", "Bennett", "Gray", "Mendoza", "Ruiz", "Hughes", "Price", "Alvarez", "Castillo", "Sanders", "Patel", "Myers", "Long", "Ross", "Foster", "Jimenez", "Powell", "Jenkins", "Perry", "Russell", "Sullivan", "Bell", "Coleman", "Butler", "Henderson", "Barnes", "Gonzales", "Fisher", "Vasquez", "Simmons", "Romero", "Jordan", "Patterson", "Alexander", "Hamilton", "Graham", "Reynolds", "Griffin", "Wallace", "Moreno", "West", "Cole", "Hayes", "Bryant", "Herrera", "Gibson", "Ellis", "Tran", "Medina", "Aguilar", "Stevens", "Murray", "Ford", "Castro", "Marshall", "Owens", "Harrison", "Fernandez", "McDonald", "Woods", "Washington" ) )
	}
} 
$customers
$customers | Export-Csv ".\Customers.csv"

function GetMovieId {
	Param(
		[int]$fNumber
	)

	return ( $movies | Where-Object -Property MovieNumber -eq $fNumber ).ID
}

function GetTheaterId {
	Param(
		[int]$fNumber
	)

	return ( $theaters | Where-Object -Property TheaterNumber -eq $fNumber ).ID
}

function GetCustomerId {
	Param(
		[int]$fNumber
	)

	return ( $customers | Where-Object -Property CustomerNumber -eq $fNumber ).ID
}

function GetMovieName {
	Param(
		[guid]$fNumber
	)

	return ( $movies | Where-Object -Property ID -eq $fNumber ).MovieName
}

function GetTheaterName {
	Param(
		[guid]$fNumber
	)

	$fTheater = $theaters | Where-Object -Property ID -eq $fNumber
	$fName = "$($fTheater.TheaterName) - $($fTheater.Location)"

	return $fName
}

function GetCustomerName {
	Param(
		[guid]$fNumber
	)

	$fCustomer = $customers | Where-Object -Property ID -eq $fNumber

	$fName = "$($fCustomer.CustomerNumber) | $($fCustomer.FirstName) $($fCustomer.LastName)"

	return $fName
}

$tickets = for ( $ticket = 1 ; $ticket -le 20000 ; $ticket++ ) {
	# Each Day

	[PSCustomObject]@{
		ID = (New-Guid).Guid
		Date = (Get-Date ((Get-Date).AddYears(-1)).AddDays((Get-Random -Minimum 0 -Maximum 183)) -Format 'yyyy-MM-dd HH:mm:ss')
		CustomerID = GetCustomerId (Get-Random -Maximum 5000 -Minimum 1)
		MovieID = GetMovieId (Get-Random -Maximum 6 -Minimum 1)
		TheaterID = GetTheaterId (Get-Random -Maximum 6 -Minimum 1)
	}
	
} 
$tickets
$tickets.Count
$tickets | Export-Csv ".\Tickets.csv"

$ticketSales = foreach ($ticket in $tickets) {
	[PSCustomObject]@{
		Date = Get-Date $ticket.Date
		Customer = GetCustomerName ($ticket.CustomerID)
		Movie = GetMovieName ($ticket.MovieID)
		Theater = GetTheaterName ($ticket.TheaterID)
	}
}

$ticketSales
$ticketSales.Count
$ticketSales | Export-Csv "TicketSalesReport.csv"
