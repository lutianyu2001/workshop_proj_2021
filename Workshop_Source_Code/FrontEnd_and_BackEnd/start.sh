cd /home/suroot/Football/django/
conda activate tmp
python manage.py runserver
conda deactivate

conda activate tmp
python -m http.server 6234
conda deactivate

cd /home/suroot/Football/vue/
npm run dev
