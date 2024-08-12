# Декомпозиция задачи

## Бизнес-логика

## Приложение

### main.rb

Подключение библиотек

Запуск View приложения с Dashboard и MainMenu.

### model.rb

App::Model

Сохранение и извлечение данных о текущем состоянии железной дороги.

#### model/base.rb

App::Model::Base

Базовый класс для работы с моделями.

Может создавать новый объект для сущности (Станция, Маршрут, Поезд, Вагон).
При создании нового объекта, помимо уже определённых в нём аттрибутов, добавляет его UUID.
Может изменять существующий объект.
Может сохранять данные об объекте в YAML-файл.
Может загружать из файла данные объекта.
Может искать объект по его UUID.
Может возвращать аттрибуты объекта как все разом, так и по отдельности.

#### model/route.rb

App::Model::Route < App::Model::Base

#### model/station.rb

App::Model::Station < App::Model::Base

#### model/train.rb

App::Model::Train < App::Model::Base

### view.rb

App::View

Показ дашборда, списков и инпутов.

#### view/base.rb

App::View::Base

Может отрисовать текущую страницу состоящую из дашборда сверху и текущего меню под ним.
Данные для дашборда и меню поступают от App::Contorller
Данные о действиях пользователя передаются в контроллер.

#### view/dashboard.rb

##### view/dashboard/routes.rb

##### view/dashboard/stations.rb

##### view/dashboard/trains.rb

#### view/menu.rb 

### view/routes.rb

#### view/routes/add.rb

#### view/routes/edit.rb

#### view/routes/list.rb

### view/stations.rb

#### view/stations/add.rb

#### view/stations/edit.rb

#### view/stations/list.rb

### view/trains.rb

#### view/trains/add.rb

#### view/trains/edit.rb

#### view/trains/list.rb

### controller.rb

App::Controller

#### controller/routes.rb

App::Contorller::Routes

#### controller/stations.rb

App::Contorller::Stations

#### controller/trains.rb

App::Controller::Trains
