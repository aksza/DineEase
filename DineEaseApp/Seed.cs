using DineEaseApp.Data;
using DineEaseApp.Models;
using Microsoft.AspNetCore.Identity;
using System.Diagnostics;

namespace DineEaseApp
{
    public class Seed
    {
        private readonly DataContext dataContext;
        public Seed(DataContext context)
        {
            this.dataContext = context;
        }

        public void SeedDataContext()
        {
            if(!dataContext.ECategories.Any())
            {
                var ecategories = new List<ECategory>()
                {
                    new ECategory()
                    {
                        ECategoryName = "slam poetry"
                    },
                    new ECategory()
                    {
                        ECategoryName = "movie night"
                    },
                    new ECategory()
                    {
                        ECategoryName = "game night"
                    }
                };
                dataContext.ECategories.AddRange(ecategories);
                dataContext.SaveChanges();
            }

            if(!dataContext.RCategories.Any()) 
            {
                var rcategories = new List<RCategory>()
                {
                    new RCategory()
                    {
                        RCategoryName = "casual dining"
                    },
                    new RCategory()
                    {
                        RCategoryName = "fast food"
                    },
                    new RCategory()
                    {
                        RCategoryName = "buffet"
                    },
                    new RCategory()
                    {
                        RCategoryName = "cafe"
                    },
                    new RCategory()
                    {
                        RCategoryName = "fast casual"
                    },
                    new RCategory()
                    {
                        RCategoryName = "contemporary casual"
                    },
                    new RCategory()
                    {
                        RCategoryName = "pub"
                    },
                    new RCategory()
                    {
                        RCategoryName = "family style"
                    },
                    new RCategory()
                    {
                        RCategoryName = "pizzerias"
                    },
                    new RCategory()
                    {
                        RCategoryName = "diner"
                    }
                };
                dataContext.RCategories.AddRange(rcategories);
                dataContext.SaveChanges();
            }

            if (!dataContext.Seatings.Any())
            {
                var seatings = new List<Seating>()
                {
                    new Seating()
                    {
                        SeatingName = "teras"
                    },
                    new Seating()
                    {
                        SeatingName = "garden"
                    },
                    new Seating()
                    {
                        SeatingName = "indoor"
                    },
                    new Seating
                    {
                        SeatingName = "second floor"
                    },
                    new Seating()
                    {
                        SeatingName = "private booth"
                    },
                    new Seating()
                    {
                        SeatingName = "bar"
                    }
                };
                dataContext.Seatings.AddRange(seatings);
                dataContext.SaveChanges();
            }


            if (!dataContext.Prices.Any())
            {
                var prices = new List<Price>()
                {
                    new Price()
                    {
                        PriceName = "cheap"
                    },
                    new Price()
                    {
                        PriceName = "average"
                    },
                    new Price()
                    {
                        PriceName = "expensive"
                    }
                };
                dataContext.Prices.AddRange(prices);
                dataContext.SaveChanges();
            }

            if (!dataContext.Cuisines.Any())
            {
                var cuisines = new List<Cuisine>()
                {
                    new Cuisine()
                    {
                        CuisineName = "italian"
                    },
                    new Cuisine()
                    {
                        CuisineName = "transylvanian"
                    },
                    new Cuisine()
                    {
                        CuisineName = "indian"
                    },
                    new Cuisine()
                    {
                        CuisineName = "vegan"
                    },
                    new Cuisine()
                    {
                        CuisineName = "vegetarian"
                    },
                    new Cuisine()
                    {
                        CuisineName = "chinese"
                    }
                };
                dataContext.Cuisines.AddRange(cuisines);
                dataContext.SaveChanges();
            }

            if (!dataContext.Owners.Any())
            {
                var owners = new List<Owner>()
                {
                    new Owner()
                    {
                        Name = "Nagy Jeno",
                        PhoneNum = "0751234567"
                    },
                    new Owner()
                    {
                        Name = "Kiss Janos",
                        PhoneNum = "0749876543"
                    }
                };
                dataContext.Owners.AddRange(owners);
                dataContext.SaveChanges();
            }

            if (!dataContext.Photos.Any())
            {
                var photos = new List<Photo>()
                {
                    new Photo()
                    {
                        Photograph = new byte[] { 0x1A, 0x2B, 0x3C, 0x4D }
                    }
                };
                dataContext.Photos.AddRange(photos);
                dataContext.SaveChanges();
            }

            if (!dataContext.Users.Any())
            {
                var users = new List<User>()
                {
                    new User()
                    {
                        PasswordHash = new byte[] { 0x1A, 0x2B, 0x3C, 0x4D },
                        PasswordSalt = new byte[] { 0x9A, 0x8B, 0x7C, 0x6D },
                        Email = "suciuaksza12@gmail.com",
                        PhoneNum = "0743869983",
                        FirstName = "Aksza",
                        LastName = "Suciu",

                    },
                    new User()
                    {
                        PasswordHash = new byte[] { 0x1A, 0x2B, 0x3C, 0x4D },
                        PasswordSalt = new byte[] { 0x9A, 0x8B, 0x7C, 0x6D },
                        Email = "nagycsongi@gmail.com",
                        PhoneNum = "074565656",
                        FirstName = "Csongor",
                        LastName = "Nagy",
                    },
                };
                dataContext.Users.AddRange(users);
                dataContext.SaveChanges();
            }

            if (!dataContext.EventTypes.Any())
            {
                var eventtypes = new List<EventType>()
                {
                    new EventType()
                    {
                        EventName = "wedding"
                    },
                    new EventType()
                    {
                        EventName = "engagement"
                    },
                    new EventType()
                    {
                        EventName = "graduation"
                    },
                    new EventType()
                    {
                        EventName = "holiday party"
                    },
                    new EventType()
                    {
                        EventName = "corporate events"
                    },
                    new EventType()
                    {
                         EventName = "other"
                    }
                };
                dataContext.EventTypes.AddRange(eventtypes);
                dataContext.SaveChanges();
            }

            

            if (!dataContext.Restaurants.Any())
            {
                var restaurants = new List<Restaurant>()
                {
                    new Restaurant()
                    {
                        Name = "G Cafe",
                        Description = "A good place",
                        Address = "Strada Cuza Vodă 33, Târgu Mureș 540027",
                        PhoneNum = "0772292460",
                        Email = "gcafe@gmail.com",
                        Rating = 3.5,
                        Price = dataContext.Prices.First(p => p.PriceName =="average"),
                        ForEvent = false,
                        Owner = dataContext.Owners.First(p => p.Name == "Nagy Jeno"),
                        MaxTableCap = 20,
                        TaxIdNum = 123456,
                        BusinessLicense = new byte[] { 0x1A, 0x2B, 0x3C, 0x4D }
                    }
                };
                dataContext.Restaurants.AddRange(restaurants);
                dataContext.SaveChanges();
            }

            if(!dataContext.MenuTypes.Any())
            {
                var menutypes = new List<MenuType>()
                {
                    new MenuType()
                    {
                        Name = "vegan"
                    },
                    new MenuType()
                    {
                        Name = "fast food"
                    },
                    new MenuType()
                    {
                        Name = "vegetarian"
                    }
                };
                dataContext.MenuTypes.AddRange(menutypes);
                dataContext.SaveChanges();
            }

            if(!dataContext.Events.Any())
            {
                var events = new List<Event>()
                {
                    new Event()
                    {
                        EventName = "Open Mic",
                        Restaurant = dataContext.Restaurants.First(p => p.Id == 1),
                        Description = "Keszulj fel Marosvasarhely, mert a Nest ismet slam poetry estet szervez a varosban! Ha szereted a formakat megbontani, es szivesen osztanad meg gondolataidat a mikrofon elott, akkor ne habozz!",
                        StartingDate = DateTime.Now,
                        EndingDate= DateTime.Now.AddHours(4)
                    }
                };
                dataContext.Events.AddRange(events);
                dataContext.SaveChanges();
            }

            if(!dataContext.Favorits.Any()) 
            {
                var favorits = new List<Favorit>()
                {
                    new Favorit()
                    {
                        User = dataContext.Users.First(p => p.FirstName == "Aksza"),
                        Restaurant = dataContext.Restaurants.First(p => p.Id == 1)

                    }
                };
                dataContext.Favorits.AddRange(favorits);
                dataContext.SaveChanges();
            }

            if (!dataContext.Ratings.Any())
            {
                var ratings = new List<Rating>()
                {
                    new Rating()
                    {
                        Restaurant = dataContext.Restaurants.First(p => p.Id == 1),
                        User = dataContext.Users.First(p => p.FirstName == "Aksza"),
                        RatingNumber = 4

                    },
                    new Rating()
                    {
                        Restaurant = dataContext.Restaurants.First(p => p.Id == 1),
                        User = dataContext.Users.First(p => p.FirstName == "Aksza"),
                        RatingNumber = 5

                    },
                };
                dataContext.Ratings.AddRange(ratings);
                dataContext.SaveChanges();
            }

            if(!dataContext.CategoriesEvents.Any())
            {
                var categoriesevents = new List<CategoriesEvent>()
                {
                    new CategoriesEvent()
                    {
                        ECategory = dataContext.ECategories.First(p => p.ECategoryName == "slam poetry"),
                        Event = dataContext.Events.First(p => p.EventName == "Open mic")
                    }
                };
                dataContext.CategoriesEvents.AddRange(categoriesevents);
                dataContext.SaveChanges();
            }

            if (!dataContext.CategoriesRestaurants.Any())
            {
                var categoriesrestaurant = new List<CategoriesRestaurant>()
                {
                    new CategoriesRestaurant()
                    {
                        Restaurant = dataContext.Restaurants.First(p => p.Id == 1),
                        RCategory = dataContext.RCategories.First(p => p.RCategoryName == "fast food")
                    },
                    new CategoriesRestaurant()
                    {
                        Restaurant = dataContext.Restaurants.First(p => p.Id == 1),
                        RCategory = dataContext.RCategories.First(p => p.RCategoryName == "pub")
                    }
                };
                dataContext.CategoriesRestaurants.AddRange(categoriesrestaurant);
                dataContext.SaveChanges();
            }

            if (!dataContext.CuisinesRestaurants.Any())
            {
                var cuisinerestaurants = new List<CuisinesRestaurant>()
                {
                    new CuisinesRestaurant()
                    {
                        Restaurant = dataContext.Restaurants.First(p => p.Id == 1),
                        Cuisine = dataContext.Cuisines.First(p => p.CuisineName == "italian")
                    },
                    new CuisinesRestaurant()
                    {
                        Restaurant = dataContext.Restaurants.First(p => p.Id == 1),
                        Cuisine = dataContext.Cuisines.First(p => p.CuisineName == "transylvanian")
                    }
                };
                dataContext.CuisinesRestaurants.AddRange(cuisinerestaurants);
                dataContext.SaveChanges();
            }

            if (!dataContext.SeatingsRestaurants.Any())
            {
                var seatingsrestaurant = new List<SeatingsRestaurant>()
                {
                    new SeatingsRestaurant()
                    {
                        Seating = dataContext.Seatings.First(p => p.SeatingName == "bar"),
                        Restaurant = dataContext.Restaurants.First(p => p.Id == 1)
                    }
                    ,
                    new SeatingsRestaurant()
                    {
                        Seating = dataContext.Seatings.First(p => p.SeatingName == "teras"),
                        Restaurant = dataContext.Restaurants.First(p => p.Id ==1)
                    }
                };
                dataContext.SeatingsRestaurants.AddRange(seatingsrestaurant);
                dataContext.SaveChanges();
            }

            if (!dataContext.Reviews.Any())
            {
                var review = new List<Review>()
                {
                    new Review()
                    {
                        Restaurant = dataContext.Restaurants.First(p => p.Id == 1),
                        User = dataContext.Users.First(p => p.FirstName == "Aksza"),
                        Content = "It was a good experince."

                    }
                };
                dataContext.Reviews.AddRange(review);
                dataContext.SaveChanges();
            }

            if (!dataContext.PhotosRestaurants.Any())
            {
                var photosrestaurants = new List<PhotosRestaurant>()
                {
                    new PhotosRestaurant()
                    {
                        Restaurant = dataContext.Restaurants.First(p => p.Id == 1),
                        Photo = dataContext.Photos.First(p => p.Id == 1),
                    }
                };
                dataContext.PhotosRestaurants.AddRange(photosrestaurants);
                dataContext.SaveChanges();
            }

            if(!dataContext.Openings.Any())
            {
                var openings = new List<Opening>()
                {
                    new Opening()
                    {
                        Restaurant = dataContext.Restaurants.First(p => p.Id == 1),
                        OpeningHour = "8:00",
                        ClosingHour = "21:00",
                        day = DayOfWeek.Monday
                    },
                    new Opening()
                    {
                        Restaurant = dataContext.Restaurants.First(p => p.Id == 1),
                        OpeningHour = "8:00",
                        ClosingHour = "21:00",
                        day = DayOfWeek.Tuesday
                    },
                    new Opening()
                    {
                        Restaurant = dataContext.Restaurants.First(p => p.Id == 1),
                        OpeningHour = "8:00",
                        ClosingHour = "21:00",
                        day = DayOfWeek.Wednesday
                    },
                    new Opening()
                    {
                        Restaurant = dataContext.Restaurants.First(p => p.Id == 1),
                        OpeningHour = "8:00",
                        ClosingHour = "21:00",
                        day = DayOfWeek.Thursday
                    },
                    new Opening()
                    {
                        Restaurant = dataContext.Restaurants.First(p => p.Id == 1),
                        OpeningHour = "9:00",
                        ClosingHour = "23:00",
                        day = DayOfWeek.Friday
                    },
                    new Opening()
                    {
                        Restaurant = dataContext.Restaurants.First(p => p.Id == 1),
                        OpeningHour = "9:00",
                        ClosingHour = "22:00",
                        day = DayOfWeek.Saturday
                    },
                    new Opening()
                    {
                        Restaurant = dataContext.Restaurants.First(p => p.Id == 1),
                        OpeningHour = "9:00",
                        ClosingHour = "21:00",
                        day = DayOfWeek.Sunday
                    }
                };
                dataContext.Openings.AddRange(openings);
                dataContext.SaveChanges();
            }

            if (!dataContext.Meetings.Any())
            {
                var meetings = new List<Meeting>()
                {
                    new Meeting()
                    {
                        Event = dataContext.EventTypes.First(p => p.EventName == "wedding"),
                        User = dataContext.Users.First(p => p.FirstName == "Aksza"),
                        Restaurant = dataContext.Restaurants.First(p => p.Id == 1),
                        EventDate = DateTime.Now.AddDays(21),
                        GuestSize = 150,
                        MeetingDate = DateTime.Now.AddDays(3),
                        PhoneNum = "0741231231",
                        Comment = "hello"
                    }
                };
                dataContext.Meetings.AddRange(meetings);
                dataContext.SaveChanges();
            }


            if(!dataContext.Menus.Any())
            {
                var menus = new List<Menu>()
                {
                    new Menu()
                    {
                        Restaurant = dataContext.Restaurants.First(p => p.Id == 1),
                        Name = "Salad box",
                        MenuType = dataContext.MenuTypes.First(p => p.Name == "vegan"),
                        Ingredients = "cucumber, pepper, tomato, salad",
                        Price = 20
                    }
                };
                dataContext.Menus.AddRange(menus);
                dataContext.SaveChanges();
            }

            if (!dataContext.Reservations.Any())
            {
                var reservations = new List<Reservation>()
                {
                    new Reservation()
                    {
                        Restaurant = dataContext.Restaurants.First(p => p.Id ==1),
                        User = dataContext.Users.First(p => p.FirstName == "Aksza"),
                        PartySize = 4,
                        Date = DateTime.Now,
                        PhoneNum = "0743869983",
                        Ordered = true,
                        Comment = "I would like to sit next to a window please",
                        Accepted = true,
                        RestaurantResponse = "okay, we are waiting for you"
                    }
                };
                dataContext.Reservations.AddRange(reservations);
                dataContext.SaveChanges();
            }

            if (!dataContext.Orders.Any())
            {
                var orders = new List<Order>()
                {
                    new Order()
                    {
                        Menu = dataContext.Menus.First(p => p.Id == 1),
                        Comment = "without pepper please",
                        Reservation = dataContext.Reservations.First(p => p.Id == 2)
                    }
                };
                dataContext.Orders.AddRange(orders);
                dataContext.SaveChanges();
            }
        }
    }
}
