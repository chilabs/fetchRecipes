
### Summary: Include screen shots or a video of your app highlighting its features

A simple recipe app that shows a list of recipes and allows you to tap in to see a detailed page with a larger image.

<img width="425" alt="Image" src="https://github.com/user-attachments/assets/e8b091fc-4540-47e5-abdc-3153bdda261f" />
<img width="431" alt="Image" src="https://github.com/user-attachments/assets/a5d56668-bed6-4a11-826e-a8a57ea6bfdf" />

### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?

I decided to focus on the image caching and using structured concurrency to ensure it is thread-safe. I focused on this area since per the instructions I couldn't use 3rd party libraries or the standard Apple libraries to achieve what I wanted.

The image cache utilizes NSCache to keep up to 50 images in memory and also saves them to disk so they can be cached across app launches. To ensure
the cache isn't stale, I keep the access time of each image in user defaults and remove images from the cache once a TTL is reached.

Expired images in the cache are removed when they are accessed or cleaned up when the app is backgrounded.

### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?

Approximately 3-4 hours.

### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?

I focused on getting something working instead of making the most perfect thing. I cache images on disk in the user cache directory and rely on the OS to clear things out when disk space is used up instead of doing any manual clean up myself. 

### Weakest Part of the Project: What do you think is the weakest part of your project?

If there was more time, I would improve the following things:

- Not use NSCache for the in memory cache as it isn't customizable in terms of caching strategy. It also doesn't take into account the image size. A few images of very large size could overwhelm the memory.
- There's no mechanism to manually expire the items in the image cache, it might make sense to do that from the server in case the image is updated.
- Limit the size of the disk cache by manually removing older images once it reaches a certain size.
- Add features like searching/filtering/sorting the list of recipes, show the youtube video on the recipe detail page
- Update list of recipes after a TTL is reached automatically, currently it only supports manual pull to refresh
- Using a dependency injection framework so it's easier to test things like singletons, etc
- Would add some additional testing for failure cases to simulate graceful handling of network errors, disk errors, etc
- For a production app, there should be error logging to the server, crash reporting, performance monitoring of load times for different screens, monitoring of memory use, cache size, etc

### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.

Apple libraries like NSCache aren't yet supported well for use in actors, as they are not sendable.
