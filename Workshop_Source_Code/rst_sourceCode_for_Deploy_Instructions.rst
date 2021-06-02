
*******************
Deploy Instructions
*******************

Enviroment Specify
==================

    Please be very carefull about the versions of the library! Any mismatching version may cause sever problem!

Your environment must have these packages in these specific versions:

+------------------+---------+
| Package          | Version |
+==================+=========+
| python           | 3.7.0   |
+------------------+---------+
| django           | 3.1.5   |
+------------------+---------+
| matplotlib       | 3.3.2   |
+------------------+---------+
| PyQt5-Qt5        | 5.15.2  |
+------------------+---------+
| numpy            | 1.19.1  |
+------------------+---------+
| pandas           | 1.1.5   |
+------------------+---------+
| mysql            | 0.0.3   |
+------------------+---------+
| mysql-connector  | 2.2.9   |
+------------------+---------+

+---------+---------+
| Package | Version |
+=========+=========+
| node.js | 15.14.0 |
+---------+---------+
| npm     | 7.15.1  |
+---------+---------+

IP Configuration
================

    As we have mentioned in our documentation, our database server and application server is not on the same host machine, thus they have different IP address.
If you want to deploy the application in your computer, you have to do a few small modifications:

    #. Firewall Configuration for port

        Remember to allow port 8000, 8080 and 6234 to have both direction access privilege

        Port Explanation:

        +------+--------------------------------+
        | Port | Explanation                    |
        +======+================================+
        | 8000 | Django back-end port           |
        +------+--------------------------------+
        | 8080 | Vue.js front-end port          |
        +------+--------------------------------+
        | 6234 | Python Simple Http Server port |
        +------+--------------------------------+

    #. SQL Server IP

        Change these IP address to your MySQL IP address (Port can also be changed, but is deprecated, please use the same port with us)

        * ./Football/django/pre/views.py: Line 17
        * ./Football/django/pre/matplotlib/plt_data.py: Line 9

    #. Front-End & Back-End IP

        Change these IP to the IP of the computer hosting our applications.

        * ./Football/vue/config/index.js:

            Line 15: IP for Django server (**DO NOT** modify the port)

            Line 21: IP for Vue server (0.0.0.0 is the best, **DO NOT** modify it if you don't know what you are doing!)

        * ./Football/django/pre/matplotlib/draw.py:

            Line 12: IP for Python Simple Http Server, **same as the Django server\'s IP**


Start the server
================

    I will assume you have started the MySQL server.

    Open three **separate** terminal, **ensure you have the administrator previlege (on Windows)**
    (for Linux, ensure you execute ``sudo -s`` in advance to gain the root privilege), then:

#. Terminal 1: for Django
    Ensure that you come to "./Football/django/" directory by command ``cd``, execute:

.. code-block:: sh
    :linenos:

    python manage.py runserver


#. Terminal 2: for Python Simple Http Server
    Ensure that you come to "./Football/" directory by command ``cd``, execute:

.. code-block:: sh
    :linenos:

    python -m http.server 6234


#. Terminal 3: for Vue.js
    Ensure that you come to "./Football/vue/" directory by command ``cd``, execute:

.. code-block:: sh
    :linenos:

    npm run dev


Ask for Help
============

If you have any problem, please feel free to contact me, my email address is: ``p930026092@mail.uic.edu.cn``
