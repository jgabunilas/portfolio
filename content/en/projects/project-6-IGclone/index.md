---
# date: 2017-04-09T10:58:08-04:00
description: "A SQL relational database exercise"
# featured_image: "/images/circularlogic_thumbnail_980x735.jpg"
featured_image: "social-media.jpg"

# tags: ["scene"]
title: "Social Media App Clone"

weight: 11
---
A SQL relational database exercise

<!--more-->


#### [View project files in Github](https://github.com/jgabunilas/mysql_bootcamp/tree/main/Section%2014-15%20-%20Instagram%20Database%20Clone)

## Introduction

In this project, we construct a relational database is construction that is intended to mimic the basic functionality of a social media application. First, the database tables defined, with key relationships established between them to enable the desired functionalities and enforce data integrity. Next, the tables are loaded with fictional data representing users, objects and actions for a typical social media site, including Likes, Comments, Photos, and Follows. Lastly, SQL commands are used to explore the data and answer pertinent questions about the application and the behavior of its users.

This exercise was completed as part of the [Ultimate MySQL Bootcamp](https://www.udemy.com/course/the-ultimate-mysql-bootcamp-go-from-sql-beginner-to-expert/) course taught be Colt Steele. 

---

## Part I: Defining the Database Schema 

The overall schema for the database is as follows:

[![](db_schema.JPG)](https://jgabunilas.github.io/images/db_schema.JPG)

The individual tables were designed as follows:

### users

![](users.JPG)

The `users` table represents the users of the social media application and contains three columns:
- **id**: a unique integer id for the user which also serves as a *primary key*. Additionally, the user id is a *foreign key* for many of the other tables.
- **username**: the username for the user. A username is required.
- **created_at**: a timestamp that indicates when the user was added to the database. Defaults to the current time

### photos
![](photos.JPG)

The `photos` table represents the photos that are posted to the application and contains four columns:
- **id**: a unique integer id for the photo which also serve as a *primary key*
- **image_url**: the URL where the image is located. A URL is required.
- **user_id**: the user to whom the photo belongs. This is a required field in order to avoid "orphan photos" with no owners. It is also a *foreign key* that references `users.id`, such that the owner must be an existing user of the application.
- **created_at**: a timestamp that indicates when the photo was added


### comments
![](comments.JPG)

The `comments` table tracks comments that users make on photos. It contains three columns:
- **id**: a unique integer id for the comment
- **comment_text**: the textual content of the comment
- **photo_id**: the id of the photo for which the comment has been left. It is a *foreign key* that references `photos.id`.
- **user_id**: the id of the user who has left the comment. It is a *foreign key* that references `users.id`.
- **created_at**: a timestamp that indicates when the comment was created

### likes
![](likes.JPG)

The `likes` table tracks the likes that users give to photos. It contains three columns:
- **user_id**: the id of the user who is giving the like. It is a *foreign key* that references `users.id`. It also forms a *composite key* with **photo_id**.
- **photo_id**: the id of the photo to which the like is given. It is a *foreign key* tha references `photos.id`. It also forms a *composite key* with **user_id**.
- **created_at**: a timestamp that indicates when the like was given

### follows
![](follows.JPG)

The `follows` table tracks which users are followed by other users on the social media application. It consists of three columns:
- **follower_id**: the user id of the user who is following another user. It is a *foreign key* that references `users.id`. It also forms a *composite key* with **followee_id**.
- **followee_id** the user id of the user who is being followed. It is a *foreign key* that references `users.id`. It also forms a *composite key* with **follower_id**.
- **created_at**: a timestamp that indicates when the follower began following the followee

If a user attempts to follow themselves, the following *database trigger* prevents them from doing so:
```
DELIMITER $$

CREATE TRIGGER prevent_self_follows
     BEFORE INSERT ON follows FOR EACH ROW
     BEGIN
         IF NEW.follower_id = NEW.followee_id
         THEN   
             SIGNAL SQLSTATE '45000'
                 SET MESSAGE_TEXT = "You cannot follow yourself.";
         END IF;
     END;
$$

DELIMITER ;
```

### unfollows
![](unfollows.JPG)

The `unfollows` table allows us to track when users decide to unfollow other users. It consists of three columns:
- **follower_id**: the user id of the user who unfollows another user. It is a *foreign key* that references `users.id`. It also forms a *composite key* with **followee_id**.
- **followee_id** the user id of the user who is unfollowed by another user. It is a *foreign key* that references `users.id`. It also forms a *composite key* with **follower_id**.
- **created_at**: a timestamp that indicates when the follower stopped following the followee.

When a row is deleted from the `follows` table (thereby indicating that an unfollow has occured), the following *database trigger* adds the deleted follower/followee pair to the `unfollows` table:
```
CREATE TRIGGER create_unfollow
    AFTER DELETE ON follows FOR EACH ROW 
BEGIN
    INSERT INTO unfollows
    SET follower_id = OLD.follower_id,
        followee_id = OLD.followee_id;
END$$
```

### tags
![](tags.JPG)

The `tags` table catalogs the unique tags (commonly known as *hashtags* in popular social media applications) that are available for users to apply to photos. It consists of two columns:
- **id**: the unique intteger id of the tag. It is a *primary key*.
- **tag_name**: the textual name of the tag
- **created_at**: a timestemp that indicates when the tag was created

### photo_tags
![](photo_tags.JPG)

The `photo_tags` table tracks which tags have been applied to which photos in the `photos` table. In this way, the `photo_tags` table relates to the tags to the photos. It consists of two columns:
- **photo_id**: the id of the photo to which the tag has been applied. It is a *foreign key* that references `photos.id`. It also forms a *composite key* with **tag_id**.
- **tag_id**: the id of the tag that has been applied to the photo. It is a *foreign key* that references `tags.id`. It also forms a *composite key* with **photo_id**. 

---
## Part 2: Populating the Database

The database tables are next populated with a large set of fictional data representing users, photos, comments, likes, and so forth. The data can be viewed [here](https://github.com/jgabunilas/mysql_bootcamp/blob/main/Section%2014-15%20-%20Instagram%20Database%20Clone/ig_clone_data.sql).

---
## Part 3: Insights

The relational is now populated database can be explored to develop new insights about the users and contents of the application.

#### Longest-tenured users
To determine the users who have been using the application the longest, we need only explore the `users` table.
![](longest-users.JPG)

#### Choosing a day for targeted advertisting at new users
Suppose our goal is to launch a new advertising campaign that will reach the greatest number of *new* users.  Again, all of the data we need is contained with the `users` table, where we can use series of string commands to count how many times a new registration timestamp was created on each day of the week. 

![](registration-day.JPG)

The data suggests that an ad will be seen by most new users on a Thursday or a Sunday.

