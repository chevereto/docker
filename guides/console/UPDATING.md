# Updating (console)

* Add the main template repository as remote `template`. *This is required just once*.
  
```sh
git remote add template https://github.com/chevereto/container-builder 
```

* Fetch `template` and merge it with `main`. This will pull all updates.

```sh
git fetch template main
git merge template/main --allow-unrelated-histories
```

* When done push the changes to your remote repository.

```sh
git push
```
