# Декомпозиция задачи

## Бизнес-логика

## Приложение

### main.rb

### app.rb

Подключение библиотек

Запуск View приложения с Dashboard и MainMenu.

### model.rb

App::Model

Сохранение и извлечение данных о текущем состоянии железной дороги.

#### model/base.rb

App::Model::Base

Базовый класс для работы с моделями.

- [ ] Может создавать новый объект для сущности (Станция, Маршрут, Поезд, Вагон).
- [ ] При создании нового объекта, помимо уже определённых в нём аттрибутов, добавляет его UUID.
- [ ] Может изменять существующий объект.
- [ ] Может сохранять данные об объекте в YAML-файл.
- [ ] Может загружать из файла данные объекта.
- [ ] Может искать объект по его UUID.
- [ ] Может возвращать аттрибуты объекта как все разом, так и по отдельности.

#### model/route.rb

App::Model::Route < App::Model::Base

#### model/station.rb

App::Model::Station < App::Model::Base

#### model/train.rb

App::Model::Train < App::Model::Base

### view.rb

App::View

Показ дашборда, списков и инпутов.

#### view/base_menu.rb

App::View::BaseMenu

#### view/dashboard.rb

App::View::Dashboard

App::View::Dashboard#routes

App::View::Dashboard#stations

App::View::Dashboard#trains


#### view/main.rb 

App::View::Main < App::View::BaseMenu

#### view/routes.rb

App::View::Routes < App::View::BaseMenu

#### view/stations.rb

App::View::Stations < App::View::BaseMenu

### view/trains.rb

App::View::Trains < App::View::BaseMenu

### controller.rb

App::Controller

#### controller/routes.rb

App::Contorller::Routes

#### controller/stations.rb

App::Contorller::Stations

#### controller/trains.rb

App::Controller::Trains
