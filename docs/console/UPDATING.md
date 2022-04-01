# Updating (console)

To update it is required to follow these steps:

1. [Update repository](#update-repository)
2. [Re-build container images](BUILD.md)
3. [Flush application volume](#flush-application-volume)
4. [Re-up containers](DOCKER-COMPOSE.md)

## Update repository

> Note: This is just one alternative. You can always fork your own way.

Add the main template repository as remote `template`. *This is required just once*.
  
```sh
git remote add template https://github.com/chevereto/container-builder 
```

Fetch `template` and merge it with `main`. This will pull all updates.

```sh
git fetch template main
git merge template/main --allow-unrelated-histories
```

When done push the changes to your remote repository.

```sh
git push
```

## Flush application volume

Run the following command to wipe the application volume:

```sh
make app-volume--flush <options>
```

Once removed, on new container `up` the application volume will be re-created with the updated Chevereto files.
