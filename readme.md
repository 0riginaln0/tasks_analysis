# Установка

Для Windows и Mac существуют готовые дистрибутивы:
 - Скачать можно тут https://livebook.dev/

На Linux я устанавливал так:

```sh
brew install elixir
mix do local.rebar --force, local.hex --force
mix escript.install hex livebook
```

> [!NOTE]
> After you install the escript, make sure you add the directory where Elixir keeps escripts to your $PATH.

# Запуск

Просто запустите дистрибутив, или пропишите в терминале 

```sh
livebook server
```

После этого в интерфейсе можно перейти к нужному проекту

